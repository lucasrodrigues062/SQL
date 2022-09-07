

----------------------------------
CREATE PROCEDURE	sym_auditoria_espelho
(
	@IdMovimento INTEGER,
	@Usuario VARCHAR(100)
)
----------------------------------
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS (SELECT 1 FROM ZMovimentoCompl zc WHERE Idmov = @IdMovimento)
	
		BEGIN 
			UPDATE ZMovimentoCompl SET sym_audit_print = sym_audit_print + @Usuario WHERE IdMov = @IdMovimento
		END
	
	ELSE
		BEGIN 
			INSERT INTO ZMovimentoCompl (IdMov, sym_audit_print) VALUES (@IdMovimento, @Usuario)
		END
		
	SET NOCOUNT OFF

	RETURN 
END;
