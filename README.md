# Saldo — versão piloto (Supabase + GitHub Pages, 100% grátis)

Esta é a versão do Saldo com login próprio: cada pessoa que criar uma conta
só vê os próprios lançamentos — diferente do Artifact, que precisava de uma
cópia separada por pessoa (uma pra você, outra pra Erika). Toda a lógica
financeira (parcelas, contas fixas, importação de fatura, dashboard,
relatórios) é a mesma que já estava pronta e testada — só a forma de
guardar os dados mudou.

## Passo a passo

### 1. Criar o projeto no Supabase
1. Entre em [supabase.com](https://supabase.com) → **New project**.
2. Dê um nome (ex.: `saldo`), crie uma senha de banco (guarde em um lugar
   seguro — você não vai precisar dela no dia a dia) e escolha uma região
   próxima (São Paulo, se aparecer, ou a mais próxima disso).
3. Espere o projeto terminar de provisionar (1-2 minutos).

### 2. Rodar o schema do banco
1. No menu lateral, abra **SQL Editor** → **New query**.
2. Cole todo o conteúdo do arquivo `schema.sql` (deste pacote) e clique em
   **Run**. Isso cria as tabelas e já deixa a regra de segurança (cada
   pessoa só vê os próprios dados) configurada.

### 3. Pegar a URL e a chave do projeto
1. Menu lateral → **Settings** → **API**.
2. Copie o campo **Project URL** e o campo **anon public** (a chave
   "service_role" NUNCA deve ir para o código do site — essa é só a
   "anon", que é pública por design).
3. Abra o arquivo `index.html`, procure por `SUPABASE_URL` e
   `SUPABASE_ANON_KEY` (perto do topo do `<script>`) e cole os dois
   valores ali, entre as aspas.

### 4. (Opcional, recomendado para o teste) Agilizar o cadastro
Por padrão, o Supabase manda um e-mail de confirmação antes de liberar o
login. Para testar rápido com amigos/parentes sem essa fricção:
1. **Authentication** → **Providers** → **Email**.
2. Desative **Confirm email**.
3. Antes de abrir para o público em geral, vale reativar essa confirmação.

### 5. Subir os arquivos para o GitHub
1. Crie um repositório novo (ex.: `saldo-app`) na sua conta do GitHub.
2. Suba os arquivos `index.html` deste pacote para a raiz do repositório
   (pode ser pelo site do GitHub mesmo: **Add file → Upload files**).

### 6. Ativar o GitHub Pages (hospedagem grátis)
1. No repositório: **Settings** → **Pages**.
2. Em "Branch", escolha `main` e a pasta `/ (root)` → **Save**.
3. Em um ou dois minutos, o link do site aparece nessa mesma tela (algo
   como `https://seu-usuario.github.io/saldo-app/`).

### 7. Testar
1. Abra o link e crie sua própria conta primeiro.
2. Confira se os botões de Dashboard, Relatórios, Contas fixas e
   Importar fatura abrem normalmente.
3. Mande o link para os amigos/parentes convidados criarem a própria conta.

## O que ficou diferente da versão Artifact (de propósito, por enquanto)

- **"Preencher por voz" com IA não funciona aqui.** O microfone do teclado
  e o preenchimento manual continuam funcionando; só a etapa de a IA
  interpretar a frase falada automaticamente fica fora, porque dependia de
  um recurso que só existe dentro da Claude. Ligar isso a uma IA externa
  teria custo por chamada — avise se quiser que eu monte essa parte depois.
- **Sem atualização "ao vivo" entre abas/aparelhos ainda.** A tela atualiza
  a cada ação sua (salvar, importar, excluir) — não enquanto outra pessoa
  está editando ao mesmo tempo em outro aparelho. Para o teste com
  amigos/parentes, cada um no próprio celular, isso não deve importar.
- **A tabela de contas fixas ficou com o nome `billTemplates`** (igual ao
  nome interno que o app já usava) — é só um detalhe técnico, não precisa
  se preocupar com isso.

## Custo

Com o volume de um teste entre amigos e parentes, tudo isso roda nos
planos grátis do Supabase e do GitHub Pages — sem cartão de crédito
cadastrado em nenhum dos dois. O único cuidado: se o projeto do Supabase
ficar **uma semana inteira sem nenhum acesso**, ele pausa automaticamente
(não é cobrado, não perde dados) — é só reativar no painel quando for
usar de novo.
