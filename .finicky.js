module.exports = {
  defaultBrowser: "Brave Browser",
  rewrite: [
    {
      // if opening meet and it comes from slack force theorem auth user
      match: ({ opener, url }) =>
        url.host === "meet.google.com" &&
        opener.path &&
        opener.path.startsWith("/Applications/Slack.app"),
      url: ({ urlString }) => urlString + "?authuser=1",
    },
  ],
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
