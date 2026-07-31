# Deploy do painel PAGAMENTOS (Supabase + GitHub + Vercel)

## 1. Supabase — criar a tabela
1. Abra o projeto no [supabase.com](https://supabase.com) que você já tem (ou crie um novo, chamado `pagamentos`).
2. Vá em **SQL Editor** > **New query**, cole o conteúdo de `supabase_setup.sql` e rode.
3. Vá em **Settings > API** e copie:
   - **Project URL**
   - **anon public** key (a chave "anon public" é feita pra ficar exposta no client — NÃO use a `service_role`, essa é secreta).

## 2. Editar o index.html com suas chaves
Abra `index.html` e troque estas duas linhas (perto do topo do primeiro `<script>`):

```js
var SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
var SUPABASE_ANON_KEY = 'SUA-CHAVE-ANON-PUBLICA-AQUI';
```

Ou via terminal (troque pelos seus valores reais):

```bash
cd pagamentos-deploy
sed -i "s#https://SEU-PROJETO.supabase.co#https://xxxxxxxx.supabase.co#" index.html
sed -i "s#SUA-CHAVE-ANON-PUBLICA-AQUI#eyJhbGciOi...#" index.html
```

## 3. GitHub — criar o repositório PAGAMENTOS

```bash
cd pagamentos-deploy
git init
git add index.html
git commit -m "Painel de pagamentos COUMMAR"

# com GitHub CLI:
gh repo create PAGAMENTOS --public --source=. --remote=origin --push

# sem GitHub CLI (crie o repo "PAGAMENTOS" pelo site primeiro, depois):
git remote add origin git@github.com:SEU-USUARIO/PAGAMENTOS.git
git branch -M main
git push -u origin main
```

> Só vá commitar o `index.html` já com as chaves preenchidas (passo 2) antes de subir — a chave `anon` é pública por design, não tem problema ela ficar no repositório, mesmo que o repo seja público.

## 4. Vercel — publicar

```bash
npm i -g vercel   # se ainda não tiver a CLI
cd pagamentos-deploy
vercel --prod
```

A CLI vai perguntar o nome do projeto — use `pagamentos`. Como é um `index.html` puro (sem build), a Vercel detecta como projeto estático e não precisa de `vercel.json`.

Ou, sem CLI: na Vercel, **Add New > Project > Import Git Repository** e escolha `PAGAMENTOS`. Framework Preset: **Other**. Nenhuma variável de ambiente é necessária (as chaves já estão no próprio `index.html`).

O link final fica algo como `https://pagamentos.vercel.app` (ou o domínio que você configurar).

## 5. Testar
Abra o link, marque um pagamento como pago, dê refresh na página — se persistir, o Supabase está funcionando. Teste também anexar um comprovante e ver se ele reaparece depois de recarregar.

## Sobre atualizações futuras
Esse painel deixou de depender do ambiente do Claude — daqui pra frente, se eu (Claude) fizer algum ajuste no código, você recebe um novo `index.html` aqui no chat, faz:

```bash
git add index.html
git commit -m "atualização"
git push
```

e a Vercel republica sozinha (o deploy é automático a cada push no GitHub, se você conectou o repositório pela Vercel).
