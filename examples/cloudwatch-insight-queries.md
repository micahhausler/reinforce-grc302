# Example Cloudwatch Logs Insight queries

## Number of operations by username

```
stats count(*) as userOps by user.username,
| sort userOps desc
| head 20
```

## Mutating operation count by user and verb

```
stats count(*) as mutatingOps by user.username, verb
| sort mutatingOps desc
| filter verb != get
| filter verb != watch
| head 20
```

## Visualize mutating operations over time

```
stats count(*) as mutatingOps by bin(5m)
| sort mutatingOps desc
| filter verb != get
| filter verb != watch
```
