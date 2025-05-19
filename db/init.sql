-- SQL para crear tablas de ejemplo y poblar con datos de prueba
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE llamadas (
  id SERIAL PRIMARY KEY,
  cliente_id INTEGER REFERENCES clientes(id),
  fecha TIMESTAMP,
  duracion INTEGER,
  sentimiento VARCHAR(20),
  resumen TEXT
);

INSERT INTO clientes (nombre, email) VALUES
('Juan Perez', 'juan@empresa.com'),
('Ana Gomez', 'ana@empresa.com');

INSERT INTO llamadas (cliente_id, fecha, duracion, sentimiento, resumen) VALUES
(1, '2025-05-18 10:00:00', 300, 'positivo', 'Cliente satisfecho con el servicio'),
(2, '2025-05-18 11:00:00', 200, 'negativo', 'Cliente molesto por demora'),
(1, '2025-05-18 12:00:00', 400, 'neutral', 'Consulta general sobre producto');

-- Generar 1000 clientes de prueba
do $$
begin
  for i in 3..1000 loop
    insert into clientes (nombre, email) values (
      'Cliente ' || i,
      'cliente' || i || '@empresa.com'
    );
  end loop;
end$$;

-- Generar 1000 llamadas de prueba (repartidas entre los clientes)
do $$
begin
  for i in 1..1000 loop
    insert into llamadas (cliente_id, fecha, duracion, sentimiento, resumen) values (
      (1 + (random() * 999)::int),
      NOW() - (interval '1 day' * (random() * 365)),
      (100 + (random() * 900)::int),
      (array['positivo','negativo','neutral'])[1 + (random() * 2)::int],
      'Llamada de prueba ' || i
    );
  end loop;
end$$;
