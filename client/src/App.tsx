import { ConnectButton, useConnectModal } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";

function App() {
  const { address } = useAccount();
  const { openConnectModal } = useConnectModal();

  return (
    <>
      <main className="flex flex-col items-center justify-between p-4">
        <div className="absolute top-2 right-2"></div>

        <nav className="bg-white dark:bg-black fixed w-full z-20 top-0 left-0 border-b border-gray-200 dark:border-gray-600">
          <div className="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
            <a href="https://flowbite.com/" className="flex items-center">
              <span className="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">TKTChain.</span>
            </a>

            <div className="flex md:order-2 items-center gap-8">
              <ul className="flex md:p-0 bg-gray-50 space-x-8  bg-black dark:border-gray-700">
                <li>Home</li>
                {address && (
                  <>
                    <li>My Tickets</li>
                    <li>My Events</li>
                  </>
                )}
              </ul>
              <ConnectButton />
            </div>
          </div>
        </nav>

        <div className="w-[900px] h-[500px] flex flex-col items-center justify-center">
          <h2 className="mb-3 text-8xl font-semibold">
            TKTChain<span className="text-indigo-600">.</span>
          </h2>
          <p className="mt-4 text-2xl text-center">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
          {!address && (
            <button
              onClick={openConnectModal}
              className="mt-6 hover:bg-indigo-600 text- py-2 px-4 border border-indigo-600 rounded transition-colors text-2xl"
            >
              Connect Wallet
            </button>
          )}
        </div>
        {/* <button className="transition-all	hover:bg-indigo-800 py-2 px-4 border border-indigo-800 text-2xl">My Events</button> */}

        {/* <div className="flex flex-wrap justify-center 2xl:w-[1500px] w-full">
          {[1, 2, 3, 4, 5, 6].map((item) => (
            <div className="rounded w-[350px]  border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:dark:border-neutral-700">
              <div className="w-full">
                <img src="/event.jpg" className="w-full h-full object-cover" />
              </div>
              <h2 className="text-2xl font-semibold">Rusa Morchiladze SOHO BATUMI</h2>
              <p className="opacity-50">Soho Batumi</p>
              <p className="text-indigo-300">14 June, Monday 23:00</p>
            </div>
          ))}
        </div> */}
      </main>
    </>
  );
}

export default App;
