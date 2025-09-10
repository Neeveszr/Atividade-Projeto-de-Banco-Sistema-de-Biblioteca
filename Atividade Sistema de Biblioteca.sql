-- Criando tabela de autores
CREATE TABLE autor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Criando tabela de livros
CREATE TABLE livro (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    id_autor INT NOT NULL REFERENCES autor(id),
    ano_publicacao INT
);

-- Criando tabela de usuários
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Criando tabela de empréstimos
CREATE TABLE emprestimo (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuario(id),
    id_livro INT NOT NULL REFERENCES livro(id),
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE
);

-- Inserindo autores
INSERT INTO autor (nome) VALUES
('Machado de Assis'),
('J. K. Rowling'),
('George Orwell'),
('Clarice Lispector');

-- Inserindo livros
INSERT INTO livro (titulo, id_autor, ano_publicacao) VALUES
('Dom Casmurro', 1, 1899),
('Harry Potter e a Pedra Filosofal', 2, 1997),
('1984', 3, 1949),
('A Hora da Estrela', 4, 1977),
('Harry Potter e a Câmara Secreta', 2, 1998);

-- Inserindo usuários
INSERT INTO usuario (nome) VALUES
('Ana'),
('Bruno'),
('Carla'),
('Diego');

-- Inserindo empréstimos
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao) VALUES
(1, 1, '2025-08-01', '2025-08-10'),
(2, 2, '2025-08-02', NULL),
(3, 3, '2025-08-05', '2025-08-15'),
(1, 5, '2025-08-07', NULL),
(4, 4, '2025-08-08', NULL);




--------------------------- DESAFIOS PROCEDURES ---------------------------
-- Q01. PROCEDURE PARA CADASTRAR NOVO USUÁRIO

CREATE PROCEDURE cadastrar_usuario(
	p_nome TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO usuario(nome)
	VALUES(p_nome);
END;
$$;
-- Q01. CHAMADA DA PROCEDURE
CALL cadastrar_usuario('Maria Eduarda')
-- CONFERIR
SELECT * FROM usuario




-- Q02. REGISTRAR NOVO LIVRO
CREATE PROCEDURE cadastrar_livro(
	p_titulo VARCHAR(150),
	p_id_autor INT,
	p_ano_publicacao INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO livro(titulo,id_autor,ano_publicacao)
	VALUES (p_titulo, p_id_autor, p_ano_publicacao);
END;
$$;
-- Q02. CHAMADA DA PROCEDURE
CALL cadastrar_livro('Charlottes Web', 7, 2023)




-- Q03. REGISTRAR DEVOLUÇÃO
CREATE PROCEDURE registrar_devolucao(
	p_id_emprestimo INT,
	p_data_devolucao DATE)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE emprestimo
	SET data_devolucao = p_data_devolucao
	WHERE id = p_id_emprestimo;
END;
$$;
-- Q03. CHAMADA DA PROCEDURE
CALL registrar_devolucao(1, '2025-09-09');
-- CONFERIR
SELECT * FROM emprestimo




-- Q04. EXCLUIR USUÁRIO E SEUS EMPRÉSTIMOS
CREATE OR REPLACE PROCEDURE excluir_usuario(
	p_id_usuario INT)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM emprestimo
	WHERE id_usuario = p_id_usuario;
	
	DELETE FROM usuario
	WHERE id = p_id_usuario;
END;
$$;
-- Q03. CHAMADA DA PROCEDURE
CALL excluir_usuario(2);
-- CONFERIR
SELECT * FROM emprestimo;
SELECT * FROM usuario;




--------------------------- DESAFIOS VIEWS ---------------------------
-- Q01.
CREATE VIEW livros_com_autores AS
SELECT l.titulo AS livro, a. nome AS autor
FROM livro l
JOIN autor a ON l.id_autor = a.id;

SELECT * FROM livros_com_autores




-- Q02.
CREATE VIEW usuarios_com_emprestimos AS
SELECT
	u.nome AS usuario, 
	l.titulo AS livro
FROM
	usuario u
JOIN
	emprestimo e ON u.id = e.id_usuario
JOIN
	livro l ON e.id_livro = l.id;

SELECT * FROM usuarios_com_emprestimos

--Q03.
CREATE VIEW emprestimos_em_aberto AS
SELECT
	u.nome AS usuario,
	l.titulo AS livro,
	e.data_emprestimo
FROM
	usuario u
JOIN
	emprestimo e ON u.id = e.id_usuario
JOIN
	livro l ON e.id_livro = l.id
WHERE
	e.data_devolucao IS NULL;

SELECT * FROM emprestimos_em_aberto;

--------------------------- DESAFIOS FUNÇÕES ---------------------------
-- Q01.
CREATE OR REPLACE FUNCTION autor_do_livro(p_id INT)
RETURNS VARCHAR AS $$
DECLARE
    v_autor VARCHAR(100);
BEGIN
    SELECT a.nome
    INTO v_autor
    FROM livro l
    JOIN autor a ON l.id_autor = a.id
    WHERE l.id = p_id;

    RETURN v_autor;
END;
$$ LANGUAGE plpgsql;




-- Q02.
CREATE OR REPLACE FUNCTION livro_emprestado(p_id INT)
RETURNS VARCHAR AS $$
DECLARE
    v_status VARCHAR(50);
BEGIN
    SELECT 
        CASE 
            WHEN e.data_devolucao IS NULL THEN 'Livro emprestado'
            ELSE 'Livro disponível'
        END
    INTO v_status
    FROM emprestimo e
    WHERE e.id_livro = p_id
    ORDER BY e.data_emprestimo DESC
    LIMIT 1;

    IF v_status IS NULL THEN
        RETURN 'Livro disponível';
    END IF;

    RETURN v_status;
END;
$$ LANGUAGE plpgsql;





-- Q03.
CREATE OR REPLACE FUNCTION usuario_com_atraso(p_id INT)
RETURNS VARCHAR AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM emprestimo e
    WHERE e.id_usuario = p_id
      AND e.data_devolucao IS NULL
      AND e.data_emprestimo <= CURRENT_DATE - INTERVAL '10 days';

    IF v_count > 0 THEN
        RETURN 'Usuário possui livros atrasados';
    ELSE
        RETURN 'Usuário em dia';
    END IF;
END;
$$ LANGUAGE plpgsql;





-- Q04.
CREATE OR REPLACE FUNCTION total_gasto_usuario(p_id INT)
RETURNS NUMERIC(10,2) AS $$
DECLARE
    v_total NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(valor), 0)
    INTO v_total
    FROM emprestimo
    WHERE id_usuario = p_id;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;
