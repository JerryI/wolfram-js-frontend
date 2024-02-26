import React from 'react';

const SponsorList = [
    {
        name: 'MitsuhaMiyamizu',
        bio: 'A medico focusing on the research of clinical and basic medicine.',
        github: "https://github.com/MitsuhaMiyamizu",
        photo: "https://github.com/MitsuhaMiyamizu.png",
        amount: 40,
    },
]

export default function SponsorshipTable() {
    return (
        <div className='container' style={{'padding-top':'1rem'}}>
            <p><svg fill="white" version="1.1" id="Capa_1" width="45px" height="45px" viewBox="0 0 168.1 168.1" >
<g>
	<path d="M 143.558 20.077 c -6.823 -3.625 -14.633 -5.699 -22.954 -5.699 c -14.66 0 -27.832 6.438 -36.526 16.515 C 75.325 20.815 62.197 14.378 47.5 14.378 c -8.313 0 -16.141 2.068 -22.957 5.699 C 9.913 27.83 0 42.774 0 60.033 c 0 4.944 0.835 9.639 2.349 14.082 c 8.125 35.202 60.155 79.606 81.733 79.606 c 20.982 0 73.512 -44.404 81.672 -79.606 c 1.514 -4.443 2.346 -9.138 2.346 -14.082 C 168.107 42.774 158.185 27.83 143.558 20.077 z z"/>
</g>
</svg></p>
            <p className="hero__subtitle" style={{ 'color': 'white', 'marginTop': '-0.6em', 'paddingBottom': '0.6em' }}>Sponsors of the project</p>
        
            <div className="margin-top--md margin-bottom--sm row">
            {SponsorList.map((props, idx) => (
                <Sponsor key={idx} {...props} />
            ))}
            </div>
        </div>
    )
}

function Sponsor({name, bio, github, photo, amount}) {
    return (
        <div className="col col--6 authorCol_node_modules-@docusaurus-theme-classic-lib-theme-BlogPostItem-Header-Authors-styles-module">
        <div className="avatar margin-bottom--sm">
          <a
            href={github}
            target="_blank"
            rel="noopener noreferrer"
            className="avatar__photo-link"
          >
            <img
              className="avatar__photo"
              src={photo}
              alt="Joel Marcey"
            />
          </a>
          <div
            className="avatar__intro"
            itemProp="author"
            itemScope=""
            itemType="https://schema.org/Person"
          >
            <div className="avatar__name">
              <a
                href={github}
                target="_blank"
                rel="noopener noreferrer"
                itemProp="url"
              >
                <span itemProp="name" style={{"color": "white"}}>{name}</span>
              </a>
            </div>
            <small className="avatar__subtitle" itemProp="description" style={{"color": "white"}}>
              {bio}
            </small>
          </div>
        </div>
      </div>
    )    
}
