import { Fragment } from 'react';
import ButtonWithInput from '../components/ButtonWithInput';
import Image from 'next/image';
import Link from 'next/link';
import { useState } from 'react';

function HomePage() {
  const [showInput1, setShowInput1] = useState(false);
  const [showInput2, setShowInput2] = useState(false);
  return (
    <Fragment>
      <section className="px-2 py-20 bg-white md:px-0">
        <div className="container items-center max-w-6xl px-8 mx-auto xl:px-5">
          <div className="flex flex-wrap items-center sm:-mx-3">
            <div className="w-full md:w-1/2 md:px-3">
              <div className="w-full pb-6 space-y-6 sm:max-w-md lg:max-w-lg md:space-y-4 lg:space-y-8 xl:space-y-9 sm:pr-5 lg:pr-0 md:pb-0">
                <h1 className="text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl md:text-4xl lg:text-5xl xl:text-6xl">
                  <span className="block text-indigo-700 xl:inline">
                    Court&nbsp;
                  </span>

                  <span className="block xl:inline">
                     Case Management System
                  </span>
                </h1>
                <p className="mx-auto text-base text-gray-500 sm:max-w-md lg:text-xl md:max-w-3xl">
                  A platform for obtaining queries on court cases.
                </p>
                <div className="relative flex flex-col sm:flex-row sm:space-x-4">
                  
                  <div className="p-3 text-white bg-indigo-700 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="w-8 h-8 "
                  viewBox="0 0 24 24"
                  strokeWidth="1.5"
                  stroke="currentColor"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                  <path d="M14 3v4a1 1 0 0 0 1 1h4"></path>
                  <path d="M5 8v-3a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2h-5"></path>
                  <circle cx="6" cy="14" r="3"></circle>
                  <path d="M4.5 17l-1.5 5l3 -1.5l3 1.5l-1.5 -5"></path>
                </svg>
              </div>
                  <div className="p-3 text-white bg-indigo-700 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="w-8 h-8 "
                  viewBox="0 0 24 24"
                  strokeWidth="1.5"
                  stroke="currentColor"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                  <path d="M8 9l3 3l-3 3"></path>
                  <line x1="13" y1="15" x2="16" y2="15"></line>
                  <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                </svg>
              </div>
                  <div className="p-3 text-white bg-indigo-700 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="w-8 h-8 "
                  viewBox="0 0 24 24"
                  strokeWidth="1.5"
                  stroke="currentColor"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                  <line x1="9.5" y1="11" x2="9.51" y2="11"></line>
                  <line x1="14.5" y1="11" x2="14.51" y2="11"></line>
                  <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path>
                  <path d="M7 5h1v-2h8v2h1a3 3 0 0 1 3 3v9a3 3 0 0 1 -3 3v1h-10v-1a3 3 0 0 1 -3 -3v-9a3 3 0 0 1 3 -3"></path>
                </svg>
              </div>
                  <div className="p-3 text-white bg-indigo-700 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="w-8 h-8 "
                  viewBox="0 0 24 24"
                  strokeWidth="1.5"
                  stroke="currentColor"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                  <polyline points="12 3 20 7.5 20 16.5 12 21 4 16.5 4 7.5 12 3"></polyline>
                  <line x1="12" y1="12" x2="20" y2="7.5"></line>
                  <line x1="12" y1="12" x2="12" y2="21"></line>
                  <line x1="12" y1="12" x2="4" y2="7.5"></line>
                  <line x1="16" y1="5.25" x2="8" y2="9.75"></line>
                </svg>
              </div>
                  <div className="p-3 text-white bg-indigo-700 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="w-8 h-8 "
                  viewBox="0 0 24 24"
                  strokeWidth="1.5"
                  stroke="currentColor"
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                  <line x1="15" y1="5" x2="15" y2="7"></line>
                  <line x1="15" y1="11" x2="15" y2="13"></line>
                  <line x1="15" y1="17" x2="15" y2="19"></line>
                  <path d="M5 5h14a2 2 0 0 1 2 2v3a2 2 0 0 0 0 4v3a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-3a2 2 0 0 0 0 -4v-3a2 2 0 0 1 2 -2"></path>
                </svg>
              </div>
                </div>
              </div>
            </div>
            <div className="w-full md:w-1/2">
              <div className="w-full h-auto overflow-hidden shadow-xl rounded-2xl">
                <Image
                  src="/hero_img.jpeg"
                  alt="HERO"
                  width="90"
                  height="50"
                  layout="responsive"
                />
              </div>
            </div>
          </div>
        </div>
      </section>
      <section className="py-16 bg-white">
          <h2 className="text-4xl font-bold tracking-tight text-center">
            Our Query Options
          </h2>
          <p className="mt-2 mb-10 text-lg text-center text-gray-600">
            Check out our list of queries you can get in below.
        </p>
        

<div className="flex flex-col items-center justify-center space-y-4">
      <ButtonWithInput 
      />
    </div>

      </section> 

      <div className="bg-gray-900">
        <footer className="flex flex-wrap items-center justify-between p-3 m-auto">
          <div className="container mx-auto flex flex-col flex-wrap items-center justify-between">
            <ul className="flex mx-auto text-white text-center">
              <li className="p-2 cursor-pointer hover:underline">
                Terms & Conditions
              </li>
              <li className="p-2 cursor-pointer hover:underline">Privacy</li>
              <li className="p-2 cursor-pointer hover:underline">Cookies</li>
            </ul>
            <div className="flex mx-auto text-white text-center">
              Copyright  © 2021
            </div>
          </div>
        </footer>
      </div>
    </Fragment>
  );
}
export default HomePage;
