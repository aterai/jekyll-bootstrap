---
layout: post
category: swing
folder: ClippedTabLabel
title: JTabbedPaneのタイトルをクリップ
tags: [JTabbedPane, JLabel]
author: aterai
pubdate: 2007-10-08T22:56:05+09:00
description: JDK 6で導入されたタブにコンポーネントを追加する機能を使って、長いタイトルのタブは文字列をクリップして表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJU-PNaRI/AAAAAAAAAUM/yAbkpSgRNVY/s800/ClippedTabLabel.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/03/horizontally-fill-tab-of-jtabbedpane.html
    lang: en
comments: true
---
## 概要
`JDK 6`で導入されたタブにコンポーネントを追加する機能を使って、長いタイトルのタブは文字列をクリップして表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJU-PNaRI/AAAAAAAAAUM/yAbkpSgRNVY/s800/ClippedTabLabel.png %}

## サンプルコード
<pre class="prettyprint"><code>class ClippedTitleTabbedPane extends JTabbedPane {
  public ClippedTitleTabbedPane() {
    super();
  }

  public ClippedTitleTabbedPane(int tabPlacement) {
    super(tabPlacement);
  }

  private Insets getTabInsets() {
    Insets i = UIManager.getInsets("TabbedPane.tabInsets");
    if (i != null) {
      return i;
    } else {
      SynthStyle style = SynthLookAndFeel.getStyle(this, Region.TABBED_PANE_TAB);
      SynthContext context = new SynthContext(
        this, Region.TABBED_PANE_TAB, style, SynthConstants.ENABLED);
      return style.getInsets(context, null);
    }
  }

  private Insets getTabAreaInsets() {
    Insets i = UIManager.getInsets("TabbedPane.tabAreaInsets");
    if (i != null) {
      return i;
    } else {
      SynthStyle style = SynthLookAndFeel.getStyle(this, Region.TABBED_PANE_TAB_AREA);
      SynthContext context = new SynthContext(
        this, Region.TABBED_PANE_TAB_AREA, style, SynthConstants.ENABLED);
      return style.getInsets(context, null);
    }
  }

  @Override public void doLayout() {
    int tabCount  = getTabCount();
    if (tabCount == 0) return;
    Insets tabInsets   = getTabInsets();
    Insets tabAreaInsets = getTabAreaInsets();
    Insets insets = getInsets();
    int areaWidth = getWidth() - tabAreaInsets.left - tabAreaInsets.right
                    - insets.left        - insets.right;
    int tabWidth  = 0; // = tabInsets.left + tabInsets.right + 3;
    int gap     = 0;

    switch (getTabPlacement()) {
    case LEFT:
    case RIGHT:
      tabWidth = areaWidth / 4;
      gap = 0;
      break;
    case BOTTOM:
    case TOP:
    default:
      tabWidth = areaWidth / tabCount;
      gap = areaWidth - (tabWidth * tabCount);
    }
    // "3" is magic number @see BasicTabbedPaneUI#calculateTabWidth
    tabWidth = tabWidth - tabInsets.left - tabInsets.right - 3;
    for (int i = 0; i &lt; tabCount; i++) {
      JComponent l = (JComponent) getTabComponentAt(i);
      if (l == null) break;
      l.setPreferredSize(new Dimension(tabWidth + (i &lt; gap ? 1 : 0), l.getPreferredSize().height));
    }
    super.doLayout();
  }

  @Override public void insertTab(
      String title, Icon icon, Component component, String tip, int index) {
    super.insertTab(title, icon, component, tip == null ? title : tip, index);
    JLabel label = new JLabel(title, SwingConstants.CENTER);
    Dimension dim = label.getPreferredSize();
    Insets tabInsets = getTabInsets();
    label.setPreferredSize(new Dimension(0, dim.height + tabInsets.top + tabInsets.bottom));
    setTabComponentAt(index, label);
  }
}
</code></pre>

## 解説
上記の`JTabbedPane`では、`JTabbedPane#setTabComponentAt(...)`メソッドを使って各タブ内に`JLabel`を追加し、そのクリップ機能を利用して長いタイトル文字列の後半を省略しています。

- 機能は[JTabbedPaneのタブを等幅にしてタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTitleTab.html)とほぼ同等
    - 文字列の長さに依存せず、左右にタブを配置した場合は全体の`1/4`の幅に、上下にタブを配置した場合はすべてのタブ幅を均等になるよう設定
    - [JTabbedPaneのタブを等幅にしてタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTitleTab.html)のように`TabbedPaneUI#paintText(...)`メソッドをオーバーライドして文字列の描画を上書きする必要がないため、ソースも短く実装も簡単

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPaneのタブを等幅にしてタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTitleTab.html)
- [JTabbedPaneのTabTitleを左揃えに変更](https://ateraimemo.com/Swing/TabTitleAlignment.html)

<!-- dummy comment line for breaking list -->

## コメント
- `tabAreaInsets`を考慮するように修正し、`TOP-LEFT`の切り替え機能を追加しました。 -- *aterai* 2008-02-26 (火) 22:15:27
- `SynthLookAndFeel`に仮？対応。 -- *aterai* 2008-03-22 (土) 12:49:05
    - `GTKLookAndFeel`に対応するのは、`JDK 1.7`以降になる予定？です。 [Bug ID: 6354790 GTK LAF: Painting bugs in JTabbedPane](https://bugs.openjdk.java.net/browse/JDK-6354790) -- *aterai* 2008-03-24 (月) 17:27:13
- `JTabbedPane#doLayout()`をオーバーライドするように変更。 -- *aterai* 2010-10-08 (金) 15:47:34
- `SynthLookAndFeel`で`setForegroundAt`が反映されないため困っていたため参考にさせていただきました。`setForegroundAt`を`Override`して`getTabComponentAt(index).setForeground(foreground)`するといい感じです。 -- *sawshun* 2012-01-05 (木) 20:23:28
    - 情報ありがとうございます。`Java 7`で修正されてなかったっけ？[Bug ID: 6939001 Nimbus: JTabbedPane setBackgroundAt and setForegroundAt have no effect](https://bugs.openjdk.java.net/browse/JDK-6939001)とか思ったのですが、よく見たらドキュメントに`It is up to the look and feel to honor this property, some may choose to ignore it.`と注意書きが追加されるだけの修正みたいですね。 -- *aterai* 2012-01-05 (木) 21:35:02
- メモ: 省略記号、`Truncating`、`3 periods(dots) ellipsis`、`CSS3`の`text-overflow`プロパティに`clip`|`ellipsis`|`string`、省略記号を表示しているのでタイトルは`ellipsis`にした方がよかったかも。 -- *aterai* 2012-06-24 (日) 05:18:37

<!-- dummy comment line for breaking list -->
