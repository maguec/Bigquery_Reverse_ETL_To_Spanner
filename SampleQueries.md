## Populate the Repo node table
```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "Repo"}'
) AS
SELECT
    repository_url AS URL,
    repository_name AS Name,
    IFNULL(public, FALSE) AS Public,
    CAST(repository_created_at AS TIMESTAMP) AS CreationDate
FROM
  `bigquery-public-data.samples.github_timeline`
WHERE
  repository_url IS NOT NULL
```


## Node table for Language
```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "Language"}'
) AS
SELECT 
  DISTINCT(repository_language) AS Language  FROM `bigquery-public-data.samples.github_timeline` WHERE repository_language IS NOT NULL;
```


## Edge table for Language
```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "IN_LANGUAGE"}'
) AS
SELECT 
  repository_url AS URL,
  repository_language AS Language,
FROM
  `bigquery-public-data.samples.github_timeline`
WHERE
  repository_url IS NOT NULL AND repository_language iS NOT NULL
```

## Seed developers but this needs more down below

```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "Developer"}'
) AS
SELECT 
  DISTINCT(repository_owner) AS Developer  FROM `bigquery-public-data.samples.github_timeline` WHERE repository_language IS NOT NULL;
```

## Populate the OWNS
```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "OWNS"}'
) AS
SELECT 
  repository_url AS URL,
  repository_owner AS Developer,
FROM
  `bigquery-public-data.samples.github_timeline`
WHERE
  repository_url IS NOT NULL AND repository_language iS NOT NULL
```


## Add more developers for data integrity

```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "Developer"}'
) AS
SELECT DISTINCT
  payload_pull_request_user_login AS Developer
FROM 
  `bigquery-public-data.samples.github_timeline` 
WHERE 
  payload_pull_request_user_login IS NOT NULL
```

## Get the PR Edge table populated

```sql
EXPORT DATA WITH CONNECTION `mague-tf.US.spanner_connection_3f95c9581445ea9c`
OPTIONS (
  uri = 'https://spanner.googleapis.com/projects/mague-tf/instances/spanner-3f95c9581445ea9c/databases/db_3f95c9581445ea9c',
  format = 'CLOUD_SPANNER',
  spanner_options = '{"table": "PR"}'
) AS
SELECT 
  repository_url AS URL, 
  payload_pull_request_user_login AS Developer,
  CAST(payload_pull_request_merged AS BOOL) AS Merged,
  payload_pull_request_head_sha AS SHA1
FROM 
  `bigquery-public-data.samples.github_timeline` 
WHERE 
  payload_pull_request_user_login IS NOT NULL 
  AND repository_url IS NOT NULL 
  AND payload_pull_request_head_sha IS NOT NULL
```

