A court case management software that has facility to extract these queries:
- get all juridical history (cases) of a person
- get all details of a case
- get all details of sessions of a court branch

---

## Authors
- taraneh abdellahi
- iman ghader

## Helper Recourse
- https://github.com/GeoBrodas/adalat-court-management


## Tech Stack

- NextJS
- Tailwind
- Mysql
- NextAuth ( Credential and Google OAuth)
- React-Hook-Forms

## Run Locally

Clone the project

```bash
  git clone https://github.com/GeoBrodas/adalat-court-management.git
```

Go to the project directory

```bash
  cd my-project
```

Install dependencies

```bash
  npm install
```

Add Environment Variables

```env
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
NEXTAUTH_URL=http://localhost:3000
MONGODB_USERNAME=
MONGODB_PASSWORD=
MONGODB_CLUSTER=
MONGODB_DATABASE=
```

Start the server

```bash
  npm run dev
```

