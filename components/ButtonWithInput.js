import { useState } from 'react';

const ButtonWithInput = ({ buttonText, placeholder }) => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="flex flex-col items-center justify-center space-y-4">
      <button
        className="flex items-center w-[1000px] px-6 py-3 text-lg text-white bg-indigo-700 hover:bg-indigo-800 rounded-2xl"
        onClick={() => setIsOpen(!isOpen)}
      >
        {buttonText}
        <svg
          xmlns="http://www.w3.org/2000/svg"
          className="w-5 h-5 ml-1"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <line x1="5" y1="12" x2="19" y2="12"></line>
          <polyline points="12 5 19 12 12 19"></polyline>
        </svg>
      </button>
      
      {isOpen && (
        <div className="mt-4 w-[20 * 1000px] bg-gray-100 p-4 rounded-2xl">
          <input
            type="text"
            placeholder={placeholder}
            className="w-full px-4 py-2 border rounded-lg text-gray-600"
          />
        </div>
      )}
    </div>
  );
};

const App = () => {
  return (
    <div className="space-y-6">
      <ButtonWithInput 
        buttonText="Get the Juridical History of a Person (case-id list)"
        placeholder="first-name last-name"
      />
      <ButtonWithInput 
        buttonText="Get the Details of a Case"
        placeholder="case-id"
      />
    </div>
  );
};

export default App;
