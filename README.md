# Fantasy Champions League 2026/27

Versão preparada para GitHub Pages com painel de administração e base de dados Supabase.

## O que já está incluído
- Classificação geral ordenada automaticamente a partir dos pontos.
- Registo de pontos por jornada e histórico dos vencedores.
- Estatísticas básicas da liga.
- Palmarés, MVP, momento da semana e chorão editáveis no painel.
- Site público em modo consulta; escrita reservada a utilizador com papel `admin`.
- Exportação de cópia JSON dos dados.

## Publicar no GitHub Pages
1. Copia `index.html`, `config.js`, `supabase-setup.sql` e a pasta `images/` para a raiz do repositório.
2. Mantém no diretório `images/` as fotografias com estes nomes: `kubota.jpg`, `tetra.jpg`, `jackass.jpg`, `mcnamara.jpg`, `nelson.jpg`, `alexandre.jpg`, `marco.jpg`, `andre.jpg`, `rafa.jpg`, `nuno.jpg`.
3. Em GitHub: Settings → Pages → Deploy from a branch → escolhe `main` e `/ (root)`.

## Ligar a base de dados e o painel privado
1. Cria um projeto em Supabase.
2. No SQL Editor, executa o conteúdo de `supabase-setup.sql`.
3. Em Authentication → Users, cria o teu utilizador administrador com email e palavra-passe.
4. No SQL Editor, executa o `UPDATE auth.users` comentado no fim do SQL, substituindo pelo teu email. Isto atribui `app_metadata.role = admin`.
5. Em Project Settings → API, copia Project URL e anon/public key para `config.js` nos campos `supabaseUrl` e `supabaseAnonKey`.
6. Faz commit e push. O site público passa a ler os dados partilhados; apenas o administrador autenticado pode gravar.

**Segurança:** nunca coloques a `service_role` key no site nem no GitHub. A proteção de escrita é aplicada pela Row Level Security no Supabase. Usa uma palavra-passe forte e ativa MFA na conta Supabase, se disponível.

## Nota sobre os pontos atuais
Os valores 309, 299, 296, 287, 258, 254, 238, 223, 217 e 206 são os totais acumulados que estavam no HTML original até à Jornada 3. Foram mantidos como base histórica (`baselineRound: 3`). As jornadas futuras são adicionadas como pontos por jornada; assim não se contam duas vezes os pontos antigos.

## Demonstração sem Supabase
Sem preencher `config.js`, o site abre em modo de demonstração e guarda alterações apenas no navegador atual (`localStorage`). Isto não sincroniza com os restantes visitantes e não é uma autenticação segura. Para uso real em grupo, liga o Supabase seguindo os passos acima.
