import { EventPreview } from "../components/EventPreview";
import { Link } from "react-router-dom";

export const Profile = () => {
  return (
    <div className="flex flex-col items-center p-4 mt-32">
      <div className="w-[900px] h-[500px] flex flex-col items-center">
        <h2 className="mb-3 text-8xl font-semibold">Profile</h2>
        <h2 className="mb-3 text-6xl font-semibold mb-8 mt-16">My Created Events</h2>
        <div className="flex flex-wrap 2xl:w-[1500px] w-full">
          {[1].map(() => (
            <EventPreview />
          ))}
          <Link
            to="/create-event"
            className="rounded w-[350px] border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:dark:border-neutral-700 flex flex-col items-center pt-12 cursor-pointer"
          >
            <p className="opacity-50 text-9xl">+</p>
            <p className="text-indigo-300 text-4xl font-">Create Event</p>
          </Link>
        </div>
        <h2 className="mb-3 text-6xl font-semibold mb-8 mt-16">Future Events</h2>
        <div className="flex flex-wrap 2xl:w-[1500px] w-full">
          {[1, 2].map(() => (
            <EventPreview />
          ))}
        </div>
        <h2 className="mb-3 text-6xl font-semibold mb-8 mt-16">Past Events</h2>
        <div className="flex flex-wrap 2xl:w-[1500px] w-full">
          {[1, 2, 3, 4, 5].map(() => (
            <EventPreview />
          ))}
        </div>
      </div>
    </div>
  );
};
