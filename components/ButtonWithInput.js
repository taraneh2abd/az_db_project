import { useState } from 'react';
// import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
// import { docco } from 'react-syntax-highlighter/dist/esm/styles/prism';

const ButtonWithInput = ({ buttonText, placeholders, buttonIndex }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [showTable, setShowTable] = useState(false);
  const [showERD, setShowERD] = useState(false);
  const [apiMessage, setApiMessage] = useState('');
  const [tableData, setTableData] = useState([]);
  const [inputs, setInputs] = useState(placeholders.reduce((acc, placeholder) => {
    acc[placeholder] = '';
    return acc;
  }, {}));
  const [selectedButton, setSelectedButton] = useState(null);

  const handleInputChange = (e, placeholder) => {
    setInputs(prevInputs => ({
      ...prevInputs,
      [placeholder]: e.target.value,
    }));
  };

const fetchApiMessage = async () => {
  try {
    const response = await fetch('http://127.0.0.1:8000/api/test_connection/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        ...inputs,
        buttonIndex: selectedButton,
      }),
    });
    const data = await response.json();
    
    console.log("API Response:", data);

    setApiMessage(data.message);
    setTableData(data.data || []);
  } catch (error) {
    console.error('Error fetching message:', error);
    setApiMessage('Error occurred while fetching data.');
    setTableData([]);
  }
};

  return (
    <div className="flex flex-col items-center justify-center space-y-4">
      <button
        className="flex items-center w-[1200px] px-8 py-3 text-lg text-white bg-indigo-700 hover:bg-indigo-800 rounded-2xl"
        onClick={() => {
          setIsOpen(!isOpen);
          setSelectedButton(buttonIndex);
        }}
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
        <div className="mt-4 w-[1200px] bg-gray-100 p-4 rounded-2xl">
          <div className="flex mt-4">
            <div className="w-[1000px] bg-gray-100 p-4 rounded-2xl">
              <div className="space-y-2">
                {placeholders.map((placeholder, index) => (
                  <input
                    key={index}
                    type="text"
                    value={inputs[placeholder]}
                    onChange={(e) => handleInputChange(e, placeholder)}
                    placeholder={placeholder}
                    className="w-full px-4 py-2 border rounded-lg text-gray-600"
                  />
                ))}
              </div>
              <div className="flex justify-center mt-4">
                <button
                  className="w-[200px] px-6 py-2 text-lg text-white bg-indigo-700 hover:bg-indigo-800 rounded-2xl"
                  onClick={() => {
                    setShowTable(true);
                    fetchApiMessage();
                  }}
                >
                  Apply
                </button>
              </div>
            </div>

            <div className="relative ml-4 w-[1000px] bg-gray-300 p-4 rounded-2xl overflow-auto max-h-[400px]">
              {/* <SyntaxHighlighter language="sql" style={docco}> */}
              {apiMessage}
              {/* </SyntaxHighlighter> */}
              <button
                className="absolute top-4 right-4 px-4 py-2 text-white bg-indigo-700 hover:bg-indigo-800 rounded-lg"
                onClick={() => setShowERD(true)}
              >
                Show ERD
              </button>

              {showERD && (
                <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
  <div className="relative bg-white p-4 rounded-lg w-[50%] h-[80%] flex items-center justify-center">
    <button
      className="absolute top-2 right-2 px-2 py-1 text-sm text-white bg-red-600 hover:bg-red-700 rounded"
      onClick={() => setShowERD(false)}
    >
      Close
    </button>
    <img src="/Final_ERD.png" alt="ERD Diagram" className="max-w-full max-h-full" />
  </div>
</div>

              )}
            </div>
          </div>

          {showTable && (
            <div className="mt-6 w-full bg-gray-200 overflow-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="bg-white text-indigo-700">
                    {tableData.length > 0 &&
                      Object.keys(tableData[0]).map((key, index) => (
                        <th
                          key={index}
                          className="px-4 py-2 border border-indigo-700 text-center"
                        >
                          {key.charAt(0).toUpperCase() + key.slice(1)}
                        </th>
                      ))}
                  </tr>
                </thead>
                <tbody>
                  {tableData.length > 0 ? (
                    tableData.map((row, index) => (
                      <tr key={index}>
                        {Object.values(row).map((value, idx) => (
                          <td
                            key={idx}
                            className="px-4 py-2 border border-indigo-700 text-center"
                          >
                            {value}
                          </td>
                        ))}
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td
                        colSpan="100%"
                        className="px-4 py-2 border border-indigo-700 text-center"
                      >
                        No data available
                      </td>
                    </tr>
                  )}
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
        buttonText="Show all Cases and their Appeal details" 
        placeholders={["person-id"]}
        buttonIndex={1}
      />
      <ButtonWithInput 
        buttonText="Show All Sessions of a Court Branch between 2 Dates" 
        placeholders={["Court-branch-id", "Start-Date","End-Date"]}
        buttonIndex={2}
      />
      <ButtonWithInput 
        buttonText="Show Juridical History of a Person (all case-id)" 
        placeholders={["Person-id", "Case type"]}
        buttonIndex={3}
      />
      <ButtonWithInput 
        buttonText="Show all cases of this Trio which always has Won" 
        placeholders={["Person-id", "Lawyer-id","Judge-id"]}
        buttonIndex={4}
      />
      <ButtonWithInput 
        buttonText="Show All Appeals of a Court Branch between 2 Dates" 
        placeholders={["Court-branch-id", "Start-Date","End-Date"]}
        buttonIndex={5}
      />
    </div>
  );
};

export default App;
