module.exports = {
  defaultBrowser: "Arc",
  rewrite: [
    // Uncomment to log incoming URL requests
    // {
    //   match: (x) => {
    //     finicky.log(JSON.stringify(x, null, 2));
    //     return true;
    //   },
    //   url: ({ urlString }) => urlString,
    // },
    {
      // if opening meet and it comes from slack force theorem auth user
      match: ({ opener, url }) =>
        url.host === "meet.google.com" &&
        opener.path &&
        [
          "com.tinyspeck.slackmacgap",
          "com.mowglii.ItsycalApp",
          "leits.MeetingBar",
        ].includes(opener.bundleId),
      url: ({ urlString }) => urlString + "?authuser=1",
    },
  ],
  handlers: [
    {
      match: /figma\.com\/file/,
      browser: "/Applications/Figma.app",
    },
    {
      match: /miro\.com\/app\/board/,
      browser: "/Applications/Miro.app",
    },
    {
      match: /notion\.so/,
      browser: "/Applications/Notion.app",
    },
    {
      match: ["zoom.us/*", finicky.matchDomains(/.*\zoom.us/), /zoom.us\/j\//],
      browser: "us.zoom.xos",
    },
    {
      // FirstAM
      match: [/.*filevine.*/, /.*localhost.*/, /.*leaddocket.*/],
      browser: "Google Chrome",
    },
  ],
};
