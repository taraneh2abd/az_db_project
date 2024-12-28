import { useState } from 'react';

const ButtonWithInput = ({ buttonText, placeholders }) => {
  const [formData, setFormData] = useState({
    field1: '',
    field2: '',
  });

  const [tableData, setTableData] = useState([]); // داده‌های جدول
  const [isOpen, setIsOpen] = useState(false); // باز و بسته کردن فرم
  const [showTable, setShowTable] = useState(false); // نمایش جدول
  const [apiMessage, setApiMessage] = useState(''); // پیام API
  const [showERD, setShowERD] = useState(false); // نمایش ERD

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const fetchApiMessage = async () => {
    try {
      // ارسال داده‌های ورودی به API
      const response = await fetch('http://127.0.0.1:8000//api/test_connection/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      // دریافت داده‌ها از API
      const data = await response.text(); // دریافت متن پاسخ
      setApiMessage(data); // ذخیره پیام API
    } catch (error) {
      console.error('Error submitting form:', error);
      setApiMessage('Error: Unable to connect to the server.');
    }
  };
  return (
    <div className="flex flex-col items-center justify-center space-y-4">
      <button
        className="flex items-center w-[1200px] px-8 py-3 text-lg text-white bg-indigo-700 hover:bg-indigo-800 rounded-2xl"
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
        <div className="mt-4 w-[1200px] bg-gray-100 p-4 rounded-2xl">
          <div className="flex mt-4">
            <div className="w-[1000px] bg-gray-100 p-4 rounded-2xl">
              <div className="space-y-2">
                {placeholders.map((placeholder, index) => (
                  <input
                    key={index}
                    type="text"
                    name={`field${index + 1}`}
                    placeholder={placeholder}
                    className="w-full px-4 py-2 border rounded-lg text-gray-600"
                    value={formData[`field${index + 1}`]}
                    onChange={handleChange}
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
              {apiMessage && <div className="text-gray-700">{apiMessage}</div>}
              <button
                className="absolute top-4 right-4 px-4 py-2 text-white bg-indigo-700 hover:bg-indigo-800 rounded-lg"
                onClick={() => setShowERD(true)}
              >
                Show ERD
              </button>

              {showERD && (
                <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
                  <div className="relative bg-white p-4 rounded-lg">
                    <button
                      className="absolute top-2 right-2 px-2 py-1 text-sm text-white bg-red-600 hover:bg-red-700 rounded"
                      onClick={() => setShowERD(false)}
                    >
                      Close
                    </button>
                    <img src="/Final_ERD.png" alt="ERD Diagram" className="max-w-full h-auto" />
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
                    {tableData.length > 0 && Object.keys(tableData[0]).map((key, index) => (
                      <th key={index} className="px-4 py-2 border border-indigo-700 text-center">
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
                          <td key={idx} className="px-4 py-2 border border-indigo-700 text-center">
                            {value}
                          </td>
                        ))}
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan="100%" className="px-4 py-2 border border-indigo-700 text-center">
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
        buttonText="Show all Evidence of all Case which these 4 persons were involved" 
        placeholders={["person-id (defendant)", "Person-id (plaintiff)", "Lawyer-id", "Judge-id"]}
      />
      <ButtonWithInput 
        buttonText="Show All Sessions of a Court Branch between 2 Dates" 
        placeholders={["Court-branch-id", "Start-Date","End-Date"]}
      />
      <ButtonWithInput 
        buttonText="Show Juridical History of a Person (all case-id)" 
        placeholders={["Person-id", "Case type"]}
      />
      <ButtonWithInput 
        buttonText="Show all cases of this Trio which always has Won" 
        placeholders={["Person-id", "Lawyer-id","Judge-id"]}
      />
      <ButtonWithInput 
        buttonText="Show All Appeals of a Court Branch between 2 Dates" 
        placeholders={["Court-branch-id", "Start-Date","End-Date"]}
      />
    </div>
  );
};

export default App;
