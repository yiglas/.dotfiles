module.exports = {
  defaultBrowser: "Brave Browser",
  handlers: [
    {
      match: "https://www.figma.com/file/*",
      browser: "Figma",
    },
    {
      match: "miro.com/app/board/*",
      browser: "Miro",
    },
    {
      match: ["zoom.us/*", finicky.matchDomains(/.*\zoom.us/), /zoom.us\/j\//],
      browser: "us.zoom.xos",
    },
    {
      // FirstAM
      match: [
        /.*teams.microsoft.com.*/,
        /.*dev.azure.com.*/,
        /.*portal.azure.com.*/,
        /.*clarityfirst.com.*/,
        /.*firstam.sharepoint.com.*/,
      ],
      browser: "Microsoft Edge",
    },
  ],
};
