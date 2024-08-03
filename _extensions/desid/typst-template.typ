
#let wideblock(content, ..kwargs) = block(..kwargs, width:100%+7cm-1cm, content)


// Fonts used in front matter, sidenotes, bibliography, and captions
#let sans-fonts = (
    "TeX Gyre Heros",
    // "Noto Sans"
  )

// Fonts used for headings and body copy
#let serif-fonts = (
  // "Harding Text Web",
  "Merriweather",
  // "Linux Libertine",
)

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#let article(
  title: [Paper Title],
  shorttitle: none,
  subtitle: none,
  authors: none,
  product: none,
  date: none,
  lang: "pt",
  region: "BR",
  version: none,
  draft: false,
  distribution: none,
  abstract: none,
  abstracttitle: none,
  publisher: none,
  documenttype: none,
  toc: none,
  toc_title: none,
  bib: none,
  first-page-footer: none,
  doc
) = {
  // Document metadata
  // set document(title: title, author: authors.map(author => author.name))

  
  // Page setup
  let lr(l, r, ..kwargs) = wideblock( inset: (top: 8pt, right:2pt), ..kwargs, 
    grid(columns: (1fr, 4fr), align(left, text(font: sans-fonts, size: 8pt, fill: gray, l)), align(right, text(font: sans-fonts, size: 8pt, fill: gray, r)))
  )
  set page(
    paper: "a4",
    margin: (left: 1cm,  right: 7cm, top: 2cm, bottom: 2cm),
    header-ascent: .5cm,
    footer-descent: .5cm, 

    // },
    // if version != none {version} else []
    // 
    header: context {
      if counter(page).get().first() > 1 {
        lr([], if shorttitle !=none {upper(shorttitle)} else {upper(documenttype)})
      }
    },
    footer: context {
      if counter(page).get().first() < 2 {
        if first-page-footer !=none {first-page-footer} else if date !=none {date}
      } else {
        lr(if date !=none {date}, [Página #counter(page).display() de #locate((loc) => { counter(page).final(loc).first() })], stroke: (top:.5pt + gray))
      }
    },
    
  )

  // Just a suttle lightness to decrease the harsh contrast
  set text(fill:luma(30),
          lang: lang,
           region: region,
           historical-ligatures: true,
          )
  
  set par(leading: .75em, justify: true, linebreaks: "optimized", first-line-indent: 1em)
  show par: set block(
    spacing: 0.65em
  )

  // Frontmatter

    //title block
    wideblock({
      set par(
        first-line-indent: 0pt
      )
      v(-.5cm)
      text(font: sans-fonts, fill:gray.lighten(60%), upper(documenttype))
      v(.5cm)
      text(font: serif-fonts, stretch: 80%, size:18pt, hyphenate: false, weight:"black", title)
      v(0.3cm)
      text(font: serif-fonts, stretch: 80%,size: 14pt, weight: "regular", hyphenate: true, subtitle)
      if abstract != none {
      block(inset: 1.5em)[#text(weight: "semibold", font:sans-fonts, size: 9pt)[#abstracttitle] #h(1em) #text(font: serif-fonts, size: 9pt)[#abstract]]
      } else {v(.5cm)}
      text(size:8pt,font: sans-fonts, fill:gray.lighten(60%),{
    // if date != none {upper(date.display("[month repr:long] [day], [year]"))}
    linebreak()
    v(-2.5em)
    if version != none {version}
  })
      
      line(length: 100%, stroke: 3pt + rgb("#316E6B"))
      v(-0.5cm)
    })
  

let tocblock() = {
          set par(first-line-indent: 0pt)
          
          [#text(size:14pt, weight:"black", [#toc_title])
          #set text(size:.75em, font: sans-fonts)
          #outline(
            title: none,
            depth: 2,
            indent: 1em
          )]
    
        }
   
    
  let authorblock() = {  
    block(width:100%, inset: 1em, fill:rgb("#316E6B").lighten(95%), radius: 10pt)[
      #set text(font: sans-fonts, size: 8pt)
      #set par(first-line-indent: 0em)
      #for (author) in authors [
          #if author.role != none [#text(weight: "bold", author.role) \ ]
          #h(1em)#author.name #if author.affiliation!=none {text(font: "SF Mono")[(#author.affiliation) \ ]}
          #if author.email != none [#h(1em)#text(size: 7pt, font: "SF Mono", author.email)]
          #v(.5em)
        ]
       
        #if product != none [
          #if product.contract != none [ *Contrato* #h(1em)#text(size: 7pt, font: sans-fonts, product.contract)#v(.5em) ]

          #if product.project != none [ *Projeto*  #h(1em)#text(size: 7pt, font: sans-fonts, product.project)#v(.5em) ]

          #if product.name != none [ *Produto* #h(1em)#text(size: 7pt, font: sans-fonts, product.name)#v(.5em) ]
          
          #if date != none {
            let (year, month, day) = date.split("-")
            let day = datetime(year: int(year), month: int(month), day: int(day))

            [ *Publicação*  #h(1em)#text(size: 7pt, font: sans-fonts, day.display("[day]/[month]/[year]"))  ]}

        ]     
        
      ] 
  }
      
        
place(dx: 6.5cm, dy:.5cm, right, block(width: 6cm, inset: 1em,)[
      #set align(left)
      #if authors != none [#authorblock()]
      #if toc !=none [#tocblock()]
])




  // Headings
  set heading(numbering: "1.1.a")
  show heading.where(level:1): it => {
    v(2em,weak:true)
    text(size:14pt, weight: "black",it)
    v(1em,weak: true)
  }

  show heading.where(level:2): it => {
    v(1.3em, weak: true)
    text(size: 13pt, weight: "regular",style: "italic",it)
    v(1em,weak: true)
  }

  show heading.where(level:3): it => {
    v(1em,weak:true)
    text(size:11pt,style:"italic",weight:"thin",it)
    v(0.65em,weak:true)
  }

  show heading: it => {
    if it.level <= 3 {it} else {}
  }


  // Tables and figures
  show figure: set figure.caption(separator: [.#h(0.5em)])
  show figure.caption: set align(left)
  show figure.caption: set text(font: sans-fonts)

  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(numbering: "I")
  
  show figure.where(kind: image): set figure(supplement: [Figure], numbering: "1")
  
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Code], numbering: "1")
  show raw: set text(font: "Lucida Console", size: 10pt)


  // Equations
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  show link: underline

  // Lists
  set enum(
    indent: 1em,
    body-indent: 1em,
  )
  show enum: set par(justify: false)
  set list(
    indent: 1em,
    body-indent: 1em,
  )
  show list: set par(justify: false)


  // Body text
  set text(
    font: serif-fonts,
    style: "normal",
    weight: "regular",
    hyphenate: true,
    size: 11pt
  )


  let margincite(citation) = context {
    if query(bibliography).len()>0 {
      let (key, supplement, form, style) = citation.fields()
      let sy= repr(supplement).slice(1,-1).split(",").filter(value => value.contains("dy."))
      let y = if sy.len()>0 {sy.at(0).replace("dy.", "").replace(" ", "")} else {none}
      if sy.len()>0 {supplement = repr(supplement).replace(sy.at(0), "").replace("[", "").replace("]", "").replace(",", "")}    
      cite(key, form: "normal", supplement: supplement)
      set text(size: 7pt)  
      
      // if y!=none {place(dy:eval(y), dx:100%+.65cm)[#block(width: 5.5cm, inset:1em)[#cite(key, form:"full", supplement: supplement)]]}

    }
  }

  show cite.where(form:"prose"): margincite  
  doc

  show bibliography: set text(font:sans-fonts)
  show bibliography: set par(justify:false)
  set bibliography(title:none)
  if bib != none {
    heading(level:1,[References])
    bib
  }


}

  




  