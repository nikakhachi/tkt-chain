export const EventPreview = () => {
  return (
    <div className="rounded w-[350px]  border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:dark:border-neutral-700">
      <div className="w-full">
        <img src="/event.jpg" className="w-full h-full object-cover" />
      </div>
      <h2 className="text-2xl font-semibold">Rusa Morchiladze SOHO BATUMI</h2>
      <p className="opacity-50">Soho Batumi</p>
      <p className="text-indigo-300">14 June, Monday 23:00</p>
    </div>
  );
};
