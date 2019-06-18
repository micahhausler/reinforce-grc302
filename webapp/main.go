package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/skuid/spec"
	"github.com/skuid/spec/lifecycle"
	"github.com/skuid/spec/middlewares"
	flag "github.com/spf13/pflag"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

type APIResponse struct {
	Message string `json:"message,omitempty"`
	Error   string `json:"error,omitempty"`
	Time    string `json:"time"`
}

func hello(w http.ResponseWriter, r *http.Request) {
	encoder := json.NewEncoder(w)
	response := APIResponse{
		Message: "Hello re:Inforce 2019!",
		Time:    time.Now().String(),
	}
	encoder.SetIndent("", "    ")
	encoder.Encode(response)
}

func Proxy(w http.ResponseWriter, req *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json; charset=utf-8")

	response := APIResponse{
		Time: time.Now().String(),
	}
	encoder := json.NewEncoder(w)
	encoder.SetIndent("", "    ")

	req.ParseForm()
	q := req.Form.Get("q")

	resp, err := http.Get(q)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		response.Error = err.Error()
		encoder.Encode(response)
		return
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	response.Message = string(body)

	encoder.Encode(response)
}

func main() {
	port := flag.IntP("port", "p", 3000, "Port to listen on")
	dir := flag.StringP("directory", "d", "/", "Directory to serve")
	level := spec.LevelPflagPCommandLine("level", "l", zapcore.InfoLevel, "Log level")
	flag.Parse()

	l, err := spec.NewStandardLevelLogger(*level)
	if err != nil {
		zap.L().Fatal("Error setting up logger", zap.Error(err))
	}
	zap.ReplaceGlobals(l)

	mux := http.NewServeMux()
	mux.HandleFunc("/proxy/", Proxy)
	mux.Handle("/serve/", http.StripPrefix("/serve/", http.FileServer(http.Dir(*dir))))
	mux.HandleFunc("/", hello)

	handler := middlewares.Apply(
		mux,
		middlewares.Logging(),
	)

	internalMux := http.NewServeMux()
	internalMux.Handle("/", handler)

	hostPort := fmt.Sprintf(":%d", *port)

	zap.L().Info("Server is starting", zap.String("listen", hostPort))

	server := &http.Server{Addr: hostPort, Handler: internalMux}
	lifecycle.ShutdownOnTerm(server)

	if err := server.ListenAndServe(); err != http.ErrServerClosed {
		zap.L().Fatal("Error listening", zap.Error(err))
	}
	zap.L().Info("Server gracefully stopped")
}
