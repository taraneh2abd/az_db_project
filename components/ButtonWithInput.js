import { useState } from 'react';

const ButtonWithInput = ({ buttonText, placeholders }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [showTable, setShowTable] = useState(false);

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
        <div className="mt-4 w-[1000px] bg-gray-100 p-4 rounded-2xl">
          <div className="space-y-2">
            {placeholders.map((placeholder, index) => (
              <input
                key={index}
                type="text"
                placeholder={placeholder}
                className="w-full px-4 py-2 border rounded-lg text-gray-600"
              />
            ))}
          </div>
          <div className="flex justify-center mt-4">
            <button
              className="w-[200px] px-6 py-2 text-lg text-white bg-indigo-700 hover:bg-indigo-800 rounded-2xl"
              onClick={() => setShowTable(true)}
            >
              Apply
            </button>
          </div>
          {showTable && (
            <div className="mt-6 w-full bg-gray-200 rounded-2xl overflow-hidden">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="bg-white text-indigo-700">
                    {Array.from({ length: 5 }).map((_, index) => (
                      <th
                        key={index}
                        className="px-4 py-2 border border-indigo-700 text-center"
                      >
                        Column {index + 1}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    {Array.from({ length: 5 }).map((_, index) => (
                      <td
                        key={index}
                        className="px-4 py-2 border border-indigo-700 text-center text-black"
                      >
                        Data {index + 1}
                      </td>
                    ))}
                  </tr>
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

const App = () => {
  return (
    <div className="space-y-6">
      <ButtonWithInput 
        buttonText="Show all Evidence of all Case wich these 4 person where involved" 
        placeholders={["person-id (defendant)", "Person-id (plaintiff)", "Lawyer-id", "Judge-id"]}
      />
      <ButtonWithInput 
        buttonText="Show All Sessions of a Court Branch between 2 Date" 
        placeholders={["Court-branch-id", "Start-Date","End-Date"]}
      />
      <ButtonWithInput 
        buttonText="Show Juridical History of a Person (all case-id)" 
        placeholders={["Person-id", "Case type"]}
      />
      <ButtonWithInput 
        buttonText="Show all cases of this Trio wich always has Won" 
        placeholders={["Person-id", "Lawyer-id","Judge-id"]}
      />
      <ButtonWithInput 
        buttonText="Show All Apeals of a Court Branch between 2 Date" 
        placeholders={["Court-branch-id", "Start-Date","End-Date"]}
      />
    </div>
  );
};

export default App;
