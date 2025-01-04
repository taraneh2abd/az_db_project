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

    const formatTableData = (data) => {
    // Replace 'N/A' with '' in the table data
    return data.map(row =>
      Object.fromEntries(
        Object.entries(row).map(([key, value]) => [key, value === 'N/A' ? '' : value])
      )
    );
  };

const fetchApiMessage = async () => {
    // Validate if 'person-id' is a number
    if (inputs['person-id'] && isNaN(inputs['person-id'])) {
      alert('person-id must be a number');
      return;
    }

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
        <div className="space-y-4">
          {/* Conditional Rendering Based on buttonIndex */}
          {buttonIndex === 2 ? (
            // Court Dropdown and Date Inputs for buttonIndex 2
            <>
              <select
                value={inputs.courtBranchName || ""}
                onChange={(e) => handleInputChange(e, "courtBranchName")}
                className="w-full px-4 py-2 border rounded-lg text-gray-600"
              >
                <option value="" disabled>
                  Select Court Branch Name
                </option>
                {[
                  "Central Court",
                  "North District Court",
                  "South District Court",
                  "East District Court",
                  "Main Street Court",
                  "High Court",
                  "Regional Court",
                  "City Hall Court",
                  "State Court",
                  "Southern Court",
                  "Lakeside Court",
                  "Northern Court",
                  "West City Court",
                ].map((name, index) => (
                  <option key={index} value={name}>
                    {name}
                  </option>
                ))}
              </select>

              <input
                type="date"
                value={inputs.startDate || ""}
                onChange={(e) => handleInputChange(e, "startDate")}
                placeholder="Start Date"
                className="w-full px-4 py-2 border rounded-lg text-gray-600"
              />
              <input
                type="date"
                value={inputs.endDate || ""}
                onChange={(e) => handleInputChange(e, "endDate")}
                placeholder="End Date"
                className="w-full px-4 py-2 border rounded-lg text-gray-600"
              />
            </>
          ) : (
            // Regular Input Fields for Other buttonIndex
            <>
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
            </>
          )}
        </div>

        {/* Apply Button */}
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
                    formatTableData(tableData).map((row, index) => (
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
        buttonText="1 - Show all (Appeal) of a person (can be empty)" 
        placeholders={["person-id"]}
        buttonIndex={1}
      />
      <ButtonWithInput 
        buttonText="2 - Show All Sessions of a Court Branch between 2 Dates" 
        placeholders={["Court-branch-id", "Start-Date: 2024-12-31","End-Date: 2024-12-31"]}
        buttonIndex={2}
      />
      <ButtonWithInput 
        buttonText="3 - Show Juridical History of a Person (verdict and cases)" 
        placeholders={["Person-id (also you can inject here)"]}
        buttonIndex={3}
      />
      <ButtonWithInput 
        buttonText="4 - Show all couples that have been in a case and their roles" 
        placeholders={[]}
        buttonIndex={4}
      />
      <ButtonWithInput 
        buttonText="5 - Count all couples that have been in a case" 
        placeholders={[]}
        buttonIndex={5}
      />
      <ButtonWithInput 
        buttonText="6 - show all evidences (case can be empty/not created OR Involved_Party may be missing)" 
        placeholders={[]}
        buttonIndex={6}
      />
      <ButtonWithInput 
        buttonText="7 - Show lawyers, plaintif and defendant of special complaint and the related case" 
        placeholders={[]}
        buttonIndex={7}
      />
      <ButtonWithInput 
        buttonText="8 - Show all people and their static roles (out of case)" 
        placeholders={[]}
        buttonIndex={8}
      />
      <ButtonWithInput 
        buttonText="9 - Show all REFERRED cases" 
        placeholders={[]}
        buttonIndex={9}
      />
      <ButtonWithInput 
        buttonText="10 - Show the case details along with the plaintiff's and defendant's names" 
        placeholders={[]}
        buttonIndex={10}
      />
    </div>
  );
};

export default App;
