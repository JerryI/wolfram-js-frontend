import React, {useState} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';

import CodeBlock from '@theme/CodeBlock';
import Sandbox from '@site/src/components/sandbox';

import Logo2 from '@site/static/img/logo2.svg';


import { useEffect, useRef } from 'react';
import ExecutionEnvironment from '@docusaurus/ExecutionEnvironment';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  const [isHover, setIsHover] = useState(false);


  const handleMouseEnter = () => {
     setIsHover(true);
  };
  const handleMouseLeave = () => {
     setIsHover(false);
  };

  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)} style={{"background-color": "var(--ifm-background-color)"}}>
      <div className="container">
      <svg width="500" height="500" version="1.1"  x="0px" y="0px"
	  viewBox="0 0 156.2 122.8" fill="var(--ifm-color-primary)">
  
      <path fill-rule="evenodd"
          id="wolf"
          class="st1"
          d="M78.9,41.2c0,0-0.8-5-1.4-6.8c3.8-3.7,4.4-4.3,8.1-7.8c0.3,7.1,0.1,10.8-0.3,19.5
  C83.2,43.9,78.9,41.2,78.9,41.2z M62.3,65.7c0,0-4-2.4-7-2.8c0.9-2,3.1-4.6,3.7-5.3c-1.1,0.4-9.4,4.1-10.2,7.2
  c2.3,0.6,4.6,1.3,6.8,2.3c-3,3.4-4.8,7.6-5.3,12.1c0,0,13.1-2,22.9-0.7c0.2,0.1,0.4,0.2,0.6,0.1l5.1,0.1l16.3,27.1l0.1,0.2
  c0,0,0,0,0,0c-30.7,11.1-52.8-9.3-57.6-16.5c0-0.1,0-0.1,0-0.2c4.3-18,9.5-39.5,18-45.9c4.4-7.7,5.7-19.1,13.6-25
  c2,6,5.1,18.3,7.3,24.3c9.4,9.4,23.6,21,33.1,25.9c1,0.6,2.3,4.6,2.3,4.6l-3.8,4.8l-40.9-4.1c-0.9-0.1-1.8-0.1-2.7-0.1
  c-2.8,0-5.7,0.3-8.5,0.8C58,69.7,62.3,65.7,62.3,65.7z M75.5,60.4c2.3-0.3,4.7,0.6,7.4,2.1c2.6-0.7,2.8-0.9,5.4-1.6
  c-3.3-2.4-6.8-5-11.7-4.3C76.2,57.9,75.8,59.2,75.5,60.4L75.5,60.4z"
      ></path>
      <g><polygon class="st2" points="27,95.4 5.9,61.8 26.8,28.7 31.5,28.7 10.7,61.8 31.6,95.3 	"></polygon></g>
      <g><polygon class="st2" points="102.4,51.7 112.2,11.1 117.7,5.6 107,49.5 105.9,54.2 	"></polygon></g>
      <g><polygon class="st2" points="125.9,95.2 146.9,61.6 126,28.5 121.3,28.5 142.2,61.6 121.2,95.1 	"></polygon></g>
  </svg>
   
        <h1 className="hero__title" style={{"color": "var(--ifm-color-primary)"}}>Wolfram Language XML</h1>
        <p className="hero__subtitle" style={{"color": "var(--ifm-color-primary-text)", 'marginTop': '-0.6em', 'paddingBottom': '0.6em' }}>A syntax extension for Wolfram Language that lets you write HTML-like markup inside a Wolfram Language Script like JSX.</p>
        <div className={styles.buttons} >
          <Link
            className="button button--secondary button--lg" style={{"background": "var(--ifm-color-primary-button)", "box-shadow": "0 0 31px -14px rgba(0, 0, 0, 0.8)", "color": "var(--ifm-color-primary-text-alt)"}}
            to="/docs/WLX/install">
            Getting started
          </Link>
        </div>

      </div>
    </header>
  );
}

export default function Home() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`Hello from ${siteConfig.title}`}
      description="Description will go into a meta tag in <head />">
      <HomepageHeader />
      <main>
   
      </main>
    </Layout>
  ); 
}
