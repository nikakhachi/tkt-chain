import { useState } from "react";

type TicketType = {
  name: string;
  priceInUSD: string;
};

export const CreateEventPage = () => {
  const [tickets, setTickets] = useState<TicketType[]>([{ name: "", priceInUSD: "0" }]);

  const addTicket = (e: any) => {
    e.preventDefault();
    setTickets((arr) => [...arr, { name: "", priceInUSD: "0" }]);
  };

  const handleTicketChange = (index: number, field: "name" | "priceInUSD", value: string) => {
    const updatedTickets = [...tickets];
    updatedTickets[index][field] = value;
    setTickets(updatedTickets);
  };

  const handleRemoveTicket = (index: number) => {
    if (tickets.length > 1) {
      setTickets((prevTickets) => prevTickets.filter((_, i) => i !== index));
    }
  };

  const createEvent = (e: any) => {
    e.preventDefault();
  };

  return (
    <div className="flex flex-col items-center p-4 mt-32">
      <div className="w-[900px] h-[500px] flex flex-col items-center">
        <h2 className="mb-3 text-8xl font-semibold">Create Event</h2>
        <p className="mt-4 text-2xl text-center">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        </p>
        <form className="w-full max-w-lg mt-12">
          <div className="flex flex-wrap -mx-3 mb-2">
            <div className="w-full px-3">
              <label className="font-bold">Event Name</label>
              <input className="w-full bg-gray-700 text-white py-3 px-4 mb-3 outline-none" />
            </div>
          </div>
          <div className="flex flex-wrap -mx-3 mb-2">
            <div className="w-full px-3">
              <label className="font-bold">Description</label>
              <textarea rows={4} className="py-3 px-4 outline-none w-full bg-gray-700"></textarea>
            </div>
          </div>
          <div className="flex flex-wrap -mx-3 mb-2">
            <label className="px-3 font-bold">Tickets</label>
            <div className="w-full px-3">
              {tickets.map((ticket, index) => (
                <div className="flex flex-wrap gap-[2%]" key={index}>
                  <input
                    placeholder="Ticket Name (VIP, Front-Row, etc.)"
                    className="w-[60%] bg-gray-700 text-white py-3 px-4 mb-3 outline-none"
                    value={ticket.name}
                    onChange={(e) => handleTicketChange(index, "name", e.target.value)}
                  />
                  <input
                    placeholder="Price in USD"
                    className="w-[25%] bg-gray-700 text-white py-3 px-4 mb-3 outline-none"
                    value={ticket.priceInUSD}
                    onChange={(e) => handleTicketChange(index, "priceInUSD", e.target.value)}
                    type="number"
                  />
                  {index > 0 ? (
                    <button
                      onClick={(e) => {
                        e.preventDefault();
                        handleRemoveTicket(index);
                      }}
                      className="w-[5%] bg-red-700 h-full text-sm"
                    >
                      X
                    </button>
                  ) : null}
                </div>
              ))}
              <button onClick={addTicket} className="px-2 border-2 border-indigo-600 font-bold text-2xl">
                +
              </button>
            </div>
          </div>
          <div className="flex flex-wrap -mx-3 mb-6">
            <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
              <label className="font-bold">Location</label>
              <input className="w-full bg-gray-700 text-white py-3 px-4 mb-3 outline-none" />
            </div>
            <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
              <label className="font-bold">Date</label>
              <input className="w-full bg-gray-700 text-white py-3 px-4 mb-3 outline-none" />
            </div>
            <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
              <label className="font-bold">Time</label>
              <input className="w-full bg-gray-700 text-white py-3 px-4 mb-3 outline-none" />
            </div>
          </div>
          <button
            onClick={createEvent}
            className="mt-6 hover:bg-indigo-600 text- py-2 px-4 border-2 border-indigo-600 rounded transition-colors text-xl mb-8"
          >
            CREATE
          </button>
        </form>
      </div>
    </div>
  );
};
