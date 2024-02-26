import React from 'react';
import {useBaseUrlUtils} from '@docusaurus/useBaseUrl';
import {useBlogPost} from '@docusaurus/theme-common/internal';
export default function BlogPostItemContainer({children, className}) {
  const {frontMatter, assets} = useBlogPost();
  const {withBaseUrl} = useBaseUrlUtils();
  const image = assets.image ?? frontMatter.image;
  return (
    <article
      className={className}
      itemProp="blogPost"
      itemScope
      itemType="http://schema.org/BlogPosting">
      {image && (
        <meta itemProp="image" content={withBaseUrl(image, {absolute: true})} />
      )}
      {children}
    </article>
  );
}
