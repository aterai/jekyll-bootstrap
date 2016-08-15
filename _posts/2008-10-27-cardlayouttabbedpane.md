---
layout: post
category: swing
folder: CardLayoutTabbedPane
title: CardLayoutを使ってJTabbedPane風のコンポーネントを作成
tags: [CardLayout, GridLayout, LayoutManager, JRadioButton, JTableHeader, JTabbedPane, DragAndDrop]
author: aterai
pubdate: 2008-10-27T13:54:48+09:00
description: CardLayoutとJRadioButtonやJTableHeaderを組み合わせてJTabbedPane風のコンポーネントを作成します。
image: https://lh3.googleusercontent.com/-i_zX5mZNCL0/VZBOp7c2kwI/AAAAAAAAN74/yEHMZL9l8xs/s800/CardLayoutTabbedPane.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2008/11/create-jtabbedpane-like-component-using.html
    lang: en
comments: true
---
## 概要
`CardLayout`と`JRadioButton`や`JTableHeader`を組み合わせて`JTabbedPane`風のコンポーネントを作成します。

{% download https://lh3.googleusercontent.com/-i_zX5mZNCL0/VZBOp7c2kwI/AAAAAAAAN74/yEHMZL9l8xs/s800/CardLayoutTabbedPane.png %}

## サンプルコード
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
    tabPanel.setBorder(BorderFactory.createEmptyBorder(1, left, 0, right));
    contentsPanel.setBorder(BorderFactory.createEmptyBorder(4, left, 2, right));
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

## 解説
このサンプルでは、`CardLayout`で`JTabbedPane`風のコンポーネントを作成しています。`CardLayout`でパネルを切り替えるためのタブには`UI`を変更してチェックアイコンを非表示にした`JRadioButton`を使用し、これらのタブを配置するタブエリア(`JPanel`)のレイアウトマネージャーに`GridLayout`を適用して、すべてのタブサイズが均等になるように設定しています。


- - - -
`CardLayout`+`JTableHeader`を使用したサンプルは、[JTableHeaderで作成したタブエリアでCardLayoutのコンテナを切り替える](http://ateraimemo.com/Swing/TableHeaderTabArea.html)に移動しました。

## 参考リンク
- [JTabbedPaneのタブをドラッグ＆ドロップ](http://ateraimemo.com/Swing/DnDTabbedPane.html)
- [TabbedPane風のタブ配置をレイアウトマネージャーで変更](http://ateraimemo.com/Swing/NewTabButton.html)
- [JTableHeaderで作成したタブエリアでCardLayoutのコンテナを切り替える](http://ateraimemo.com/Swing/TableHeaderTabArea.html)

<!-- dummy comment line for breaking list -->

## コメント
- `CloseButton`(ダミー)を追加。 -- *aterai* 2008-10-29 (水) 18:14:02

<!-- dummy comment line for breaking list -->
