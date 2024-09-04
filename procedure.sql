CREATE OR REPLACE PROCEDURE bank_statement(
	IN p_client_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
	counter INTEGER := 0;
	end_loop INTEGER;
	current_balance INTEGER;
	transaction_id INTEGER;
	transaction_type CHAR(1);
	transaction_description VARCHAR(10);
	transaction_value INTEGER;
	transaction_date TIMESTAMP;
BEGIN
	-- Get current balance
	SELECT saldo INTO current_balance
	FROM clients
	WHERE id = p_client_id;

	RAISE NOTICE 'Cliente: %', p_client_id;
	RAISE NOTICE 'Saldo atual: %', current_balance;


	WHILE counter < 10 LOOP
		counter := counter + 1;
		WITH ordered_transactions AS (
			SELECT
				*,
				RANK() OVER (PARTITION BY cliente_id ORDER BY realizada_em DESC) AS trans_rank
			FROM
				transactions
			WHERE
				cliente_id = p_client_id
		)
		SELECT
			id, tipo, descricao, valor, realizada_em
		INTO
			transaction_id, transaction_type, transaction_description, transaction_value, transaction_date
		FROM
			ordered_transactions
		WHERE
			trans_rank = counter;
		RAISE NOTICE 'ID Transacao: %', transaction_id;
		RAISE NOTICE 'Tipo: %', transaction_type;
		RAISE NOTICE 'Descricao: %', transaction_description;
		RAISE NOTICE 'Valor: %', transaction_value;
		RAISE NOTICE 'Realizada em: %', transaction_date;
	END LOOP;
	
END;
$$;