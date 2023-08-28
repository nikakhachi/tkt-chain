import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { Link, Outlet } from "react-router-dom";

export const Nav = () => {
  const { address } = useAccount();

  return (
    <>
      <nav className="bg-white dark:bg-black fixed w-full z-20 top-0 left-0 border-b border-gray-200 dark:border-gray-600">
        <div className="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
          <Link to="/" className="flex items-center">
            <span className="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">TKTChain.</span>
          </Link>

          <div className="flex md:order-2 items-center gap-8">
            <ul className="flex space-x-8">
              <li>
                <Link to="/">Home</Link>
              </li>
              {address && (
                <>
                  <li>
                    <Link to="/profile">Profile</Link>
                  </li>
                </>
              )}
            </ul>
            <ConnectButton />
          </div>
        </div>
      </nav>
      <div id="detail">
        <Outlet />
      </div>
    </>
  );
};
