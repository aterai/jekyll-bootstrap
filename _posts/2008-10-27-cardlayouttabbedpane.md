---
layout: post
title: CardLayoutを使ってJTabbedPane風のコンポーネントを作成
category: swing
folder: CardLayoutTabbedPane
tags: [CardLayout, GridLayout, LayoutManager, JRadioButton, JTableHeader, JTabbedPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-10-27

## CardLayoutを使ってJTabbedPane風のコンポーネントを作成
`CardLayout`と`JRadioButton`や`JTableHeader`を組み合わせて`JTabbedPane`風のコンポーネントを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIbe7vt7I/AAAAAAAAASw/SGFMcgCN_r4/s800/CardLayoutTabbedPane.png)

### サンプルコード
<pre class="prettyprint"><code>class CardLayoutTabbedPane extends JPanel {
  protected final CardLayout cardLayout = new CardLayout();
  protected final JPanel tabPanel = new JPanel(new GridLayout(1, 0, 0, 0));
  protected final JPanel wrapPanel = new JPanel(new BorderLayout(0, 0));
  protected final JPanel contentsPanel = new JPanel(cardLayout);
  protected final ButtonGroup bg = new ButtonGroup();
  public CardLayoutTabbedPane() {
    super(new BorderLayout());
    int left  = 1;
    int right = 3;
    tabPanel.setBorder(BorderFactory.createEmptyBorder(1,left,0,right));
    contentsPanel.setBorder(BorderFactory.createEmptyBorder(4,left,2,right));
    wrapPanel.add(tabPanel);
    wrapPanel.add(new JLabel("test:"), BorderLayout.WEST);
    add(wrapPanel, BorderLayout.NORTH);
    add(contentsPanel);
  }
  public void addTab(final String title, final Component comp) {
    JRadioButton b = new TabButton(new AbstractAction(title) {
      @Override public void actionPerformed(ActionEvent e) {
        cardLayout.show(contentsPanel, title);
      }
    });
    tabPanel.add(b);
    bg.add(b);
    b.setSelected(true);
    contentsPanel.add(comp, title);
    cardLayout.show(contentsPanel, title);
  }
}
</code></pre>

### 解説
`CardLayout`で`JTabbedPane`風のコンポーネントを作成すると、タブエリアのレイアウトをネストしてコンポーネントの追加したり、レイアウトマネージャーを変更することで、タブの配置を変更することが簡単になります。

- `CardLayout`+`JRadioButton`
    - 上記のサンプルでは、`JRadioButton`を`GridLayout`で、均等なサイズになるように並べています。
    - `UI`を変更して、チェックは非表示にしています。
    - マウスでタブを押した時ではなく、 ~~(`Opera`風に)~~ 放した時に切り替わります。

<!-- dummy comment line for breaking list -->

- `CardLayout`+`JTableHeader`
    - 空の`JTable`を作成して`JTableHeader`を取り出して利用しています。
    - `JTableHeader`のドラッグ＆ドロップによる入れ替えや、ヘッダ(タブ)幅のリサイズが利用できます。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTabbedPaneのタブをドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTabbedPane.html)
- [TabbedPane風のタブ配置をレイアウトマネージャーで変更](http://terai.xrea.jp/Swing/NewTabButton.html)

<!-- dummy comment line for breaking list -->

### コメント
- `CloseButton`(ダミー)を追加。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-29 (水) 18:14:02

<!-- dummy comment line for breaking list -->

