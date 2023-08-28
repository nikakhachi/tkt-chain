import { useConnectModal } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { EventPreview } from "./components/EventPreview";

function App() {
  const { address } = useAccount();
  const { openConnectModal } = useConnectModal();

  return (
    <>
      <main className="flex flex-col items-center justify-between p-4">
        <div className="w-[900px] h-[500px] flex flex-col items-center justify-center">
          <h2 className="mb-3 text-8xl font-semibold">
            TKTChain<span className="text-indigo-600">.</span>
          </h2>
          <p className="mt-4 text-2xl text-center">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
          {!address ? (
            <button
              onClick={openConnectModal}
              className="mt-6 hover:bg-indigo-600 text- py-2 px-4 border border-indigo-600 rounded transition-colors text-2xl"
            >
              Connect Wallet
            </button>
          ) : (
            <>
              <button className="mt-6 hover:bg-indigo-600 text- py-2 px-4 border border-indigo-600 rounded transition-colors text-2xl">
                CREATE EVENT
              </button>
            </>
          )}
        </div>

        <div className="flex flex-wrap justify-center 2xl:w-[1500px] w-full">
          {[1, 2, 3, 4, 5, 6].map((item) => (
            <EventPreview />
          ))}
        </div>
      </main>
    </>
  );
}

export default App;
