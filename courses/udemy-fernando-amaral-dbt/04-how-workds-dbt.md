# 04 - HowWorks DBT

## Observações**

Arquivos `.sql` em `.models`

+ Não terminar em `;`
Você precisa salvar os arquivo na IDE
  + Pois senâo,nao executa o  `mmodel`

## CTE no SQL `chatgpt`

Uma CTE (Common Table Expression), em português "Expressão Comum de Tabela", é uma construção SQL que permite definir uma tabela temporária nomeada dentro de uma consulta SQL. Essa tabela temporária pode ser referenciada na mesma consulta, permitindo uma forma mais organizada e legível de escrever consultas complexas.

As CTEs são definidas usando a cláusula `WITH`, seguida pelo nome da CTE e sua definição entre parênteses. A CTE pode então ser referenciada na consulta principal que segue a cláusula `WITH`.

Por exemplo, considere uma consulta que envolve a junção de duas tabelas, filtragem dos resultados e ordenação. Em vez de escrever toda a lógica em uma única consulta complexa, você pode usar uma CTE para dividir a consulta em partes mais gerenciáveis e compreensíveis.

Aqui está um exemplo simples de como uma CTE pode ser usada:

```sql
WITH VendasPorProduto AS (
    SELECT produto_id, SUM(quantidade) AS total_vendido
    FROM vendas
    GROUP BY produto_id
)
SELECT produtos.nome, VendasPorProduto.total_vendido
FROM produtos
JOIN VendasPorProduto -- Usou a CTE criada anteriormente
    ON produtos.id = VendasPorProduto.produto_id;
```

Neste exemplo, a CTE `VendasPorProduto` calcula o total de vendas por produto a partir da tabela `vendas`. Em seguida, essa CTE é referenciada na consulta principal para recuperar o nome do produto e o total vendido.

As vantagens das CTEs incluem:

1. **Legibilidade e Manutenção:** CTEs permitem que consultas complexas sejam divididas em partes mais gerenciáveis e compreensíveis, melhorando a legibilidade e facilitando a manutenção do código SQL.

2. **Reutilização de Código:** CTEs podem ser referenciadas em várias consultas dentro do mesmo escopo, permitindo a reutilização de lógica de consulta em diferentes partes de um script SQL.

3. **Otimização de Desempenho:** Em alguns casos, os sistemas de banco de dados podem otimizar consultas que usam CTEs de maneira mais eficiente do que consultas aninhadas ou subconsultas.

4. **Criação de Consultas Recursivas:** CTEs podem ser recursivas, o que permite escrever consultas que envolvem estruturas de dados recursivas, como árvores hierárquicas.

Em resumo, as CTEs são uma poderosa ferramenta no SQL que oferece uma maneira mais organizada e legível de escrever consultas complexas, melhorando a manutenção do código e facilitando a reutilização de lógica de consulta.

## Problemas encontrados

+ **Problema:** dbt está como read-only e nao permite escrever nada  
  + **Solução:** Crie uma branch nova, nela você vai poder fazer as cosias
