import React from 'react';
import clsx from 'clsx';
import {ThemeClassNames} from '@docusaurus/theme-common';
import {useDoc} from '@docusaurus/theme-common/internal';
import Heading from '@theme/Heading';
import MDXContent from '@theme/MDXContent';

import Link from '@docusaurus/Link'

import css from './styles.css';
/**
 Title can be declared inside md content or declared through
 front matter and added manually. To make both cases consistent,
 the added title is added under the same div.markdown block
 See https://github.com/facebook/docusaurus/pull/4882#issuecomment-853021120

 We render a "synthetic title" if:
 - user doesn't ask to hide it with front matter
 - the markdown content does not already contain a top-level h1 heading
*/
function useSyntheticTitle() {
  const {metadata, frontMatter, contentTitle} = useDoc();
  const shouldRender =
    !frontMatter.hide_title && typeof contentTitle === 'undefined';
  if (!shouldRender) {
    return null;
  }
  return metadata.title;
}

const registeredTags = {}; 

['env', 'virtual', 'needsContainer', 'update', 'source', 'origin', 'registered'];

registeredTags.env = (a) => {
  console.log('env!!');
  console.log(a);

  const list = a.map((el) => {
    if (el === 'WLJS') {
      return(<>
        <Link
                className='envBlock'
                to="/exwljs">
                {el}
        </Link>
      </>)
    } else {
    return(<>
    <Link
            className='envBlock'
            to="/exwl">
            {el}
    </Link>
  </>)}
  });

  return (<>
    <div className='envContainer'>{list}</div>  
    <div className='envTextInfo'>Execution environment</div>

  </>);
}

registeredTags.virtual = (a) => {
  console.log('virtual!!');

  if (a != true) return false;

  return (<>
          <Link
                className='envContainer'
                to="/virtual">
                <div className='emphs' style={{'background':'var(--ifm-color-primary-light)'}}>Virtual</div>
        </Link>
  </>);
}

registeredTags.needsContainer = (a) => {
  console.log('virtual!!');

  if (a != true) return false;

  return (<>
  <Link
                className='envContainer'
                to="/container"><div style={{'background': 'var(--ifm-color-content-secondary)'}} className='emphs'>Needs container</div></Link>

  </>);
}

registeredTags.update = (a) => {
  console.log('virtual!!');

  if (a != true) return false;

  return (<>
    <Link
                className='envContainer'
                to="/update"><div style={{'background': 'var(--ifm-color-success-lightest)'}} className='emphs'>Supports updates</div></Link>
  </>);
}

registeredTags.registered = (a) => {
  console.log('virtual!!');

  if (a != true) return (<></>);

  return (<>
     <Link
                className='envContainer'
                to="/registered"><div style={{'background': 'var(--ifm-color-info-darkest)'}} className='emphs'>Registered</div></Link>
  </>);
}

function ShowTags({fm}) {
  console.log(fm);
  const list = [];

  Object.keys(fm).forEach((el) => {
    if (Object.keys(registeredTags).indexOf(el) > -1) {
      const k = registeredTags[el](fm[el]);
      if (k) {
        list.push(<><div className='refTagsHolder-item'>{k}</div></>);
      }
    }
  });

  if (list.length < 1) return (<></>);

  return (<>
    <div className='refTagsHolder'>{list}</div>
  </>)
}

export default function DocItemContent({children}) {
  const syntheticTitle = useSyntheticTitle();
  const {frontMatter} = useDoc();
  return (
    <div className={clsx(ThemeClassNames.docs.docMarkdown, 'markdown')}>
      {syntheticTitle && (
        <header>
          <Heading as="h1">{syntheticTitle}</Heading>
          <ShowTags fm={frontMatter}/>
        </header>
      )}
      <MDXContent>{children}</MDXContent>
    </div>
  );
}
