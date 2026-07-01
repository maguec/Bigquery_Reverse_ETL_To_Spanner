```sql
GRAPH Github
MATCH (d:Developer)-[pr:PR]->(r:Repo)-[il:IN_LANGUAGE]->(l:Language)
WHERE l.Language = "Python" AND pr.Merged = TRUE
RETURN COUNT(d.Developer) as DevCount, d.Developer as Dev 
ORDER BY DevCount DESC LIMIT 10;
```

```sql
GRAPH Github
MATCH p=(d:Developer{Developer:"glogiotatidis"})-[pr:PR{Merged: TRUE}]->(r:Repo)-[il:IN_LANGUAGE]->(l:Language)
return SAFE_TO_JSON(p) as JSON


```sql
GRAPH Github
MATCH (d:Developer)-[pr:PR]->(r:Repo)-[il:IN_LANGUAGE]->(l:Language)
WHERE l.Language = "Python" AND pr.Merged = TRUE
RETURN COUNT(r.URL) as RepoCount, d.Developer as Dev 
ORDER BY RepoCount DESC LIMIT 10;

```

```

