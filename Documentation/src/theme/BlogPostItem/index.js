import React from 'react';
import clsx from 'clsx';
import {useBlogPost} from '@docusaurus/theme-common/internal';
import BlogPostItemContainer from '@theme/BlogPostItem/Container';
import BlogPostItemHeader from '@theme/BlogPostItem/Header';
import BlogPostItemContent from '@theme/BlogPostItem/Content';
import BlogPostItemFooter from '@theme/BlogPostItem/Footer';

import GiscusComponent from '@site/src/components/GiscusComponent';

// apply a bottom margin in list view
function useContainerClassName() {
  const {isBlogPostPage} = useBlogPost();
  return !isBlogPostPage ? 'margin-bottom--xl' : undefined;
}
export default function BlogPostItem({children, className}) {
  const { metadata, isBlogPostPage } = useBlogPost()

  const { frontMatter, slug, title } = metadata
  const { enableComments } = frontMatter

  const containerClassName = useContainerClassName();
  return (
    <BlogPostItemContainer className={clsx(containerClassName, className)}>
      <BlogPostItemHeader />
      <BlogPostItemContent>{children}</BlogPostItemContent>
      <BlogPostItemFooter />
      {(enableComments && isBlogPostPage) && (
        <GiscusComponent />
      )}
    </BlogPostItemContainer>
  );
}
