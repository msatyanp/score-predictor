import { LoginForm } from "@/components/auth/login-form";

const LoginPage = () => {
  return (
    <main className="flex items-center justify-center bg-[url('/images/login-bg.webp')] bg-cover bg-center w-full min-w-full mx-auto max-w-6xl flex-1 gap-6 px-4 py-10 sm:px-6 lg:grid-cols-1 lg:px-8">
      <section className="flex items-center justify-center rounded-md w-auto max-h-max border border-zinc-200 bg-white p-6 shadow-sm">
        <div className="flex flex-col gap-6 items-center">
          <p className="text-sm font-semibold uppercase tracking-[0.16em] text-emerald-700">
            Login
          </p>
          <h1 className="mt-3 text-3xl font-semibold tracking-normal text-zinc-950">
            Welcome back
          </h1>
          <LoginForm />
        </div>
      </section>
    </main>
  );
};

export default LoginPage;
