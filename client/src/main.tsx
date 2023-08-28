import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import "./index.css";
import "@rainbow-me/rainbowkit/styles.css";
import { darkTheme, getDefaultWallets, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import { configureChains, createConfig, WagmiConfig } from "wagmi";
import { goerli, hardhat } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";
import { Profile } from "./pages/Profile.tsx";
import { Nav } from "./components/Nav.tsx";
import { CreateEventPage } from "./pages/CreateEventPage.tsx";
import { EventPage } from "./pages/EventPage.tsx";

const { chains, publicClient } = configureChains(
  [import.meta.env.DEV ? hardhat : goerli],
  [import.meta.env.DEV ? publicProvider() : alchemyProvider({ apiKey: import.meta.env.VITE_ALCHEMY_API_KEY as string })]
);

const { connectors } = getDefaultWallets({
  appName: "tktchain",
  projectId: import.meta.env.VITE_PROJECT_ID,
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
});

const router = createBrowserRouter([
  {
    path: "/",
    element: <Nav />,
    // errorElement: <ErrorPage />,
    children: [
      {
        path: "/",
        element: <App />,
      },
      {
        path: "profile",
        element: <Profile />,
      },
      {
        path: "create-event",
        element: <CreateEventPage />,
      },
      {
        path: "event/:id",
        element: <EventPage />,
      },
    ],
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <WagmiConfig config={wagmiConfig}>
      <RainbowKitProvider chains={chains} theme={darkTheme()}>
        <RouterProvider router={router} />
      </RainbowKitProvider>
    </WagmiConfig>
  </React.StrictMode>
);
