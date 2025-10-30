program Example;

uses
  pqconnection,
  sqldb;

var
  Connection : TSQLConnection;
  Query : TSQLQuery;
  Transaction : TSQLTransaction;

begin
  Connection := TPQConnection.Create(Nil);
  Connection.DatabaseName := 'pgvector_pascal_test';

  Transaction := TSQLTransaction.Create(Connection);
  Transaction.Database := Connection;

  Query := TSQLQuery.Create(Connection);
  Query.Database := Connection;
  Query.Transaction := Transaction;

  Query.SQL.Text := 'CREATE EXTENSION IF NOT EXISTS vector';
  Query.ExecSQL;

  Query.SQL.Text := 'DROP TABLE IF EXISTS items';
  Query.ExecSQL;

  Query.SQL.Text := 'CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))';
  Query.ExecSQL;

  Query.SQL.Text := 'INSERT INTO items (embedding) VALUES ((:embedding1)::vector), ((:embedding2)::vector)';
  Query.Params.ParamByName('embedding1').AsString := '[1,2,3]';
  Query.Params.ParamByName('embedding2').AsString := '[4,5,6]';
  Query.ExecSQL;

  Query.SQL.Text := 'SELECT * FROM items ORDER BY embedding <-> (:embedding)::vector LIMIT 5';
  Query.Params.ParamByName('embedding').AsString := '[3,1,2]';
  Query.Open;
  while not Query.EOF do
  begin
    writeln(Query.FieldByName('id').AsString);
    Query.Next;
  end;
  Query.Close;

  Transaction.Commit;
  Connection.Free;
end.
