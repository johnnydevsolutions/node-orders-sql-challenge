export function requireJwtSecret(): string {
  const secret = process.env.JWT_SECRET?.trim();
  
  if (!secret) {
    throw new Error('JWT_SECRET é obrigatório (.env)');
  }
  
  // Bloqueia qualquer segredo "placeholder" 
  const looksLikePlaceholder = 
    /secret|change|your|super|secure|example|placeholder/i.test(secret) || 
    secret.length < 32;
    
  if (looksLikePlaceholder) {
    throw new Error(
      'JWT_SECRET inválido. Gere um segredo aleatório (>= 32 chars): ' +
      'node -e "console.log(require(\'crypto\').randomBytes(64).toString(\'hex\'))"'
    );
  }
  
  return secret;
}