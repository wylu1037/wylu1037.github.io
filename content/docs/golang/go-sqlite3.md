---
title: Sqlite3
date: 2024-04-24T10:14:44+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

<h4 align="center">嵌入式数据库</h4>

{{< cards >}}
{{< card link="https://github.com/mattn/go-sqlite3" title="go-sqlite3" subtitle="sqlite3 driver for go" icon="github" >}}
{{< card link="https://github.com/canonical/go-dqlite" title="dqlite" subtitle="Go bindings for libdqlite" icon="github" >}}
{{< card link="https://github.com/chaisql/chai" title="chai" subtitle="Modern embedded SQL database" icon="github" >}}
{{< /cards >}}

## 1.介绍

**SQLite** 是一个 <u>进程内</u> 的库，实现了自给自足的、无服务器的、零配置的、事务性的 **_SQL_** 数据库引擎。
**SQLite** 的一个重要的特性是零配置的，这意味着不需要复杂的 {{< font "orange" "安装" >}} 或 管理。

检查机器是否安装有 **sqlite** 的环境

```shell
sqlite3

SQLite version 3.39.5 2022-10-14 20:58:05
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
```

## 2.SQLC

[Generate type-safe code from SQL](https://github.com/sqlc-dev/sqlc)

在项目根路径新建 `sqlc.yaml` 或 `sqlc.json` 文件。

```yaml
version: "2"
sql:
  - engine: "sqlite"
    queries: "sql/query.sql" # DML、DQL
    schema: "sql/schema.sql" # DDL
    gen:
      go:
        package: "database" # go package name
        out: "./" # directory name, same as package
        emit_json_tags: true
        json_tags_case_style: camel # pascal, snake
```

### 2.1 Schema and queries

创建 schema.sql

```sql {filename="schema.sql"}
-- 存证数据表
create table ledger_record
(
    -- 主键ID
    id                        integer primary key,
    -- 数据ID：用于从链上检索数据
    data_id                   varchar(66) not null,
    -- 交易哈希
    transaction_hash          varchar(66) not null,
    -- 业务名称
    business_name             varchar(60) not null,
    -- 业务合约地址： zltc_jNkDqNCKntZq5U4jX723r6b23tzULRD9s
    business_contract_address varchar(38) not null,
    -- 协议名称
    protocol_name             varchar(30) not null,
    -- 协议号
    protocol_uri              integer     not null,
    -- 创建时间
    created_at                date        not null,
    -- 更新时间
    updated_at                date        not null
);
```

创建 query.sql

```sql {filename="query.sql"}
-- name: InsertLedgerData :one
insert into ledger_record(data_id, transaction_hash, business_name, business_contract_address, protocol_name,
                          protocol_uri, created_at, updated_at)
values (?, ?, ?, ?, ?, ?, ?, ?)
returning *;

-- name: UpdateLedgerRecord :exec
update ledger_record
set data_id                   = ?,
    transaction_hash          = ?,
    business_name             = ?,
    business_contract_address = ?,
    protocol_name             = ?,
    protocol_uri              = ?,
    created_at                = ?,
    updated_at                = ?
where id = ?;

-- name: DeleteLedgerRecord :exec
delete
from ledger_record
where id = ?;

-- name: CountLedgerRecord :one
select count(1)
from ledger_record;

-- name: GetLedgerRecordById :one
select id,
       data_id,
       transaction_hash,
       business_name,
       business_contract_address,
       protocol_name,
       protocol_uri,
       created_at,
       updated_at
from ledger_record
where id = ?
limit 1;

-- name: GetLedgerRecordByTransactionHash :one
select id,
       data_id,
       transaction_hash,
       business_name,
       business_contract_address,
       protocol_name,
       protocol_uri,
       created_at,
       updated_at
from ledger_record
where transaction_hash = ?
limit 1;
```

其中 `-- name: CreateAuthor :one` 的注释作用如下：

- `-- name: CreateAuthor`：指定了在生成的 `go` 代码中的方法名。
- `:one`：是一个指令，指示 SQLC 该查询预期返回的结果数量。

<h6>其它指令：</h6>

- `:many`：表示查询预期返回多行结果。当你的 **SQL** 语句设计为检索多个记录时，如列表或集合，你会使用这个指令。生成的 **Go** 函数将返回一个切片，包含查询到的所有实体。
- `:exec`：指示 **SQLC** 生成的函数不应期望从数据库获取任何行数据，而是仅执行给定的 **SQL** 命令，比如 `INSERT`、`UPDATE`、`DELETE`。这类操作通常关注影响的行数而不是实际的数据行。
- `:scalar`：用于查询预期只返回单个标量值的场景，比如计数 (`COUNT(*)`) 或者聚合函数的结果。生成的 **Go** 函数将返回单个值，而不是一个实体或行的集合。

`RETURNING *` 的作用
在数据库 SQL 语句中，RETURNING \*; 语句主要用于在执行数据修改操作（如 INSERT, UPDATE, 或 DELETE）后立即返回被修改的行的全部列值。

### 2.2 生成代码

运行命令：

```shell
sqlc generate
```

然后，在 `database` 目录下生成 `db.go`, `models.go`, `query.sql.go`：

{{< filetree/container >}}
{{< filetree/folder name="database" >}}
{{< filetree/folder name="sql" >}}
{{< filetree/file name="query.sql" >}}
{{< filetree/file name="schema.sql" >}}
{{< /filetree/folder >}}
{{< /filetree/folder >}}
{{< filetree/file name="db.go" >}}
{{< filetree/file name="models.go" >}}
{{< filetree/file name="query.sql.go" >}}
{{< filetree/file name="sqlc.yaml" >}}
{{< /filetree/container >}}

### 2.3 使用生成的代码

```go
package main

import (
	"context"
	"database/sql"
	_ "embed"
	"log"
	"reflect"

	_ "github.com/mattn/go-sqlite3"

	"tutorial.sqlc.dev/app/tutorial"
)

//go:embed schema.sql
var ddl string


func NewQueries() *Queries {
	// open db file
	db, err := sql.Open("sqlite3", "file:./data.db")
	if err != nil {
		log.Error().Err(err).Msg("failed to open database")
	}

	// create tables
	if _, err := db.ExecContext(context.Background(), ddl); err != nil {
		log.Error().Err(err).Msg("failed to execute ddl")
	}

	return New(db)
}

func run() error {
	q := database.NewQueries()

	num, err := q.CountLedgerRecord(context.Background())
	if err != nil {
		return
	}
	fmt.Println(num)

	r, _ := q.GetLedgerRecordById(context.Background(), 1)
	fmt.Println(r)

	if record, err := q.InsertLedgerData(context.Background(), database.InsertLedgerDataParams{
		DataID:                  "0xuSStvBbROSM08bqXAoV925Pm75oXBb4mGRwmzV9kpJ4PQxH5e2SMvav8KHyF09my",
		TransactionHash:         "0xf39473d8b801b82b503a699f3523e532f651ba95fc8341b80a3fc1bbf863dde0",
		BusinessName:            "学生存证业务",
		BusinessContractAddress: "zltc_S5KXbs6gFkEpSnfNpBg3DvZHnB9aasa6Q",
		ProtocolName:            "Student",
		ProtocolUri:             64424509445,
		CreatedAt:               time.Now(),
		UpdatedAt:               time.Now(),
	}); err != nil {
		log.Error().Err(err).Msg("failed to insert ledger data")
	} else {
		fmt.Println(record)
	}
}

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}
```

### 2.4 修改 schema

```sql
CREATE TABLE authors (
  id          SERIAL PRIMARY KEY,
  birth_year  int    NOT NULL
);

ALTER TABLE authors ADD COLUMN bio text NOT NULL;
ALTER TABLE authors DROP COLUMN birth_year;
ALTER TABLE authors RENAME TO writers;
```

{{< callout >}}
**_sqlc_** 暂不支持删除表。
{{< /callout >}}
