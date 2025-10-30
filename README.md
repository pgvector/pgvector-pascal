# pgvector-pascal

[pgvector](https://github.com/pgvector/pgvector) examples for Pascal

Supports [SQLDB](https://www.freepascal.org/docs-html/fcl/sqldb/)

[![Build Status](https://github.com/pgvector/pgvector-pascal/actions/workflows/build.yml/badge.svg)](https://github.com/pgvector/pgvector-pascal/actions)

## Getting Started

Follow the instructions for your database library:

- [SQLDB](#sqldb)

## SQLDB

Enable the extension

```pascal
Query.SQL.Text := 'CREATE EXTENSION IF NOT EXISTS vector';
Query.ExecSQL;
```

Create a table

```pascal
Query.SQL.Text := 'CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))';
Query.ExecSQL;
```

Insert vectors

```pascal
Query.SQL.Text := 'INSERT INTO items (embedding) VALUES ((:embedding1)::vector), ((:embedding2)::vector)';
Query.Params.ParamByName('embedding1').AsString := '[1,2,3]';
Query.Params.ParamByName('embedding2').AsString := '[4,5,6]';
Query.ExecSQL;
```

Get the nearest neighbors

```pascal
Query.SQL.Text := 'SELECT * FROM items ORDER BY embedding <-> (:embedding)::vector LIMIT 5';
Query.Params.ParamByName('embedding').AsString := '[3,1,2]';
Query.Open;
while not Query.EOF do
begin
  writeln(Query.FieldByName('id').AsString);
  Query.Next;
end;
Query.Close;
```

Add an approximate index

```pascal
Query.SQL.Text := 'CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)';
// or
Query.SQL.Text := 'CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)';
Query.ExecSQL;
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

See a [full example](example.pp)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-pascal/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-pascal/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-pascal.git
cd pgvector-pascal
createdb pgvector_pascal_test
fpc example.pp
./example
```

Specify the path to libpq if needed:

```sh
ln -s /opt/homebrew/opt/libpq/lib/libpq.dylib libpq.dylib
```
