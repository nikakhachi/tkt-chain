import { useConnectModal } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { EventPreview } from "../components/EventPreview";

export const Profile = () => {
  const { address } = useAccount();
  const { openConnectModal } = useConnectModal();

  return (
    <>
      <h1>Profile</h1>
    </>
  );
};
