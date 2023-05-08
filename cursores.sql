CREATE DATABASE cursores_exercicio
GO
USE cursores_exercicio
GO
CREATE TABLE curso(
codigo		            INT             NOT NULL,
nome		            VARCHAR(100)    NOT NULL,
duracao		            INT             NOT NULL
PRIMARY KEY(codigo)
)
GO 
CREATE TABLE disciplina(
codigo		            INT             NOT NULL,
nome		            VARCHAR(100)    NOT NULL,
carga_horaria		    INT             NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina_curso(
codigo_disciplina		INT             NOT NULL,
codigo_curso			INT             NOT NULL
PRIMARY KEY(codigo_disciplina,codigo_curso),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY (codigo_curso) REFERENCES curso(codigo)
)
GO
INSERT INTO curso VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logistica', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600)
GO 
INSERT INTO disciplina VALUES 
(1, 'Algoritmos', 80),
(2, 'Administração', 80),
(3, 'Laboratório de Hardware', 40),
(4, 'Pesquisa Operacional', 80),
(5, 'Física I', 80),
(6, 'Físico Química', 80),
(7, 'Comércio Exterior', 80),
(8, 'Fundamentos de Marketing', 80),
(9, 'Informática', 40),
(10, 'Sistemas de Informação', 80)
GO
INSERT INTO disciplina_curso VALUES
(1,48),
(2,48),
(2,51),
(2,73),
(2,94),
(3,48),
(4,51),
(5,67),
(6,67),
(7,51),
(7,73),
(8,51),
(8,73),
(9,51),
(9,73),
(10,48),
(10,94)

--Criar uma UDF (Function) cuja entrada é o código do curso e, com um cursor, monte uma
--tabela de saída com as informações do curso que é parâmetro de entrada.
--(Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)
GO
CREATE FUNCTION fn_lista_disciplina_cursos(@codigo INT)
RETURNS @tabela TABLE(
nome_disciplina			VARCHAR(150),
carga_horaria			INT,
nome_curso				VARCHAR(150)
)
AS
BEGIN
	DECLARE
	@nome_disciplina	VARCHAR(150),
	@carga_horaria		INT,
	@nome_curso			VARCHAR(150)
	DECLARE cur CURSOR FOR
		SELECT d.nome, d.carga_horaria, c.nome
		FROM disciplina d, curso c, disciplina_curso dc
		WHERE d.codigo = dc.codigo_disciplina
			AND c.codigo = dc.codigo_curso
			AND c.codigo = @codigo
	OPEN cur
	FETCH NEXT FROM cur INTO @nome_disciplina, @carga_horaria,@nome_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
			INSERT INTO @tabela VALUES
			(@nome_disciplina, @carga_horaria, @nome_curso)
 
		FETCH NEXT FROM cur INTO @nome_disciplina, @carga_horaria,@nome_curso
	END
	CLOSE cur
	DEALLOCATE cur
	RETURN
END

SELECT * FROM fn_lista_disciplina_cursos(48)
