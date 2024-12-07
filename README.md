
A court case management software that has facility to record information like adding a case,
adding lawyers (have facility select from existing list of lawyers), add invoice for
for each hearing and for different heads under which lawyers charge the clients.
In short the system should provide end to end management of court cases from a
client perspective and should be easy to use.

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

