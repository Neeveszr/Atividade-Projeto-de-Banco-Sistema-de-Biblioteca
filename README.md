📚 Atividade de Projeto de Banco de dados - Sistema de biblioteca

Este projeto tem o objetivo utilizar um **sistema de biblioteca** em PostgreSQL para estudar **procedures** , **views** e **functions** para gerenciar usuários, autores, livros e empréstimos.

## 🏗️ Estrutura do Banco de Dados

### Tabelas
- **autor** → informações dos autores de livros  
- **livro** → cadastro de livros com referência ao autor  
- **usuario** → cadastro de usuários da biblioteca  
- **emprestimo** → controle de empréstimos e devoluções  


## 🏗️ Explicação
Procedures:
São conjuntos de comandos SQL armazenados no banco, que podem ser executados sob demanda.
Servem para automatizar tarefas repetitivas ou complexas (ex.: atualizar estoque, gerar relatórios).

## 📝 Questões respondidas

### Questões de PROCEDURES
Questão 1 – Cadastrar novo usuário
Crie uma procedure chamada cadastrar_usuario que receba como parâmetro o nome do usuário e insira o registro na tabela usuario.

Questão 2 – Registrar novo livro
Crie uma procedure cadastrar_livro que receba como parâmetros:
título do livro,
id do autor,
ano de publicação.
A procedure deve inserir o livro na tabela livro

Questão 3 – Registrar devolução
Crie uma procedure registrar_devolucao que receba o id do empréstimo e a data de devolução.
Ela deve atualizar o registro na tabela emprestimo

Questão 4 – Excluir usuário e seus empréstimos
Crie uma procedure excluir_usuario que receba o id do usuário e:
Exclua todos os empréstimos desse usuário.
Exclua o usuário da tabela usuario.


### Questões de VIEWS
Questão 1 - Criar uma view livros_com_autores que mostre o título do livro e o nome do autor.

Questão 2 - Criar uma view usuarios_com_emprestimos que mostre o nome do usuário e os títulos dos livros emprestados.

Questão 3 - Criar uma view emprestimos_em_aberto que mostre todos os empréstimos que ainda não têm data de devolução.

Questão 4 - Criar uma view historico_emprestimos que traga: nome do usuário, título do livro, autor e data de empréstimo.

Questão 5 - Criar uma view qtd_emprestimos_por_usuario que mostre quantos livros cada usuário já emprestou.

Questão 6 - Criar uma view livros_mais_recentes que liste os livros publicados depois de 1950 com seus autores.

Questão 7 - Criar uma view usuarios_com_mais_de_um_emprestimo que mostre os usuários que já emprestaram mais de 1 livro.


### Questões de FUNCTIONS
Questão 1 - Crie uma função chamada autor_do_livro(p_id INT) que retorne o nome do autor de um livro a partir do id do livro.

Questão 2 - 
Crie uma função chamada livro_emprestado(p_id INT) que retorne:
"Livro emprestado" → se o último empréstimo do livro não tiver data de devolução.
"Livro disponível" → caso contrário.

Questão 3 -
Crie uma função chamada usuario_com_atraso(p_id INT) que retorne:
"Usuário possui livros atrasados" → se tiver empréstimos não devolvidos há mais de 10 dias.
"Usuário em dia" → caso contrário.

Questão 4 -
Para usar uma função de soma, vamos alterar a base de dados:
ALTER TABLE emprestimo ADD COLUMN valor NUMERIC(10,2);
atualizando os dados:
-- Atualizando valores manualmente
UPDATE emprestimo SET valor = 5.00 WHERE id = 1;
UPDATE emprestimo SET valor = 7.50 WHERE id = 2;
UPDATE emprestimo SET valor = 6.00 WHERE id = 3;
UPDATE emprestimo SET valor = 4.50 WHERE id = 4;
UPDATE emprestimo SET valor = 8.00 WHERE id = 5;
Crie uma função chamada total_gasto_usuario que receba o id de um usuário e retorne o valor total gasto em empréstimos, somando todos os valores da coluna valor da tabela emprestimo.
Se o usuário não tiver empréstimos, a função deve retornar 0.
