---
layout: post
title: JTabbedPaneにタブを閉じるアイコンを追加
category: swing
folder: TabWithCloseIcon
tags: [JTabbedPane, Icon, JButton]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-03-20

## JTabbedPaneにタブを閉じるアイコンを追加
`JTabbedPane`にタブを閉じるためのアイコンやボタンを追加します。以下の参考リンクから引用したコードをほぼそのまま引用して紹介しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTVFao3q4I/AAAAAAAAAnE/SarJyg-AIQk/s800/TabWithCloseIcon.png)

### サンプルコード
<pre class="prettyprint"><code>public class JTabbedPaneWithCloseIcons extends JTabbedPane {
  public JTabbedPaneWithCloseIcons() {
    super();
    addMouseListener(new MouseAdapter() {
      public void mouseClicked(MouseEvent e) {
        tabClicked(e);
      }
    });
  }
  public void addTab(String title, Component component) {
    this.addTab(title, component, null);
  }
  public void addTab(String title, Component component, Icon extraIcon) {
    super.addTab(title, new CloseTabIcon(extraIcon), component);
  }
  private void tabClicked(MouseEvent e) {
    int index = getUI().tabForCoordinate(this, e.getX(), e.getY());
    if(index&lt;0) return;
    Rectangle rect = ((CloseTabIcon)getIconAt(index)).getBounds();
    if(rect.contains(e.getX(), e.getY())) {
      removeTabAt(index);
    }
  }
}
</code></pre>

### 解説
- `JTabbedPaneWithCloseButton`(上)
    - `TabbedPaneLayout`を使用して、ボタンをタブの中にレイアウト
- `JTabbedPaneWithCloseIcons`(中)
    - `JTabbedPane`の、タブにアイコンを表示する機能を利用
    - タブのクリックされた位置がアイコン上かどうかで、そのタブを閉じるかどうかを判断
- `CloseableTabbedPane`(下)
    - `JTabbedPaneWithCloseIcons`の改良版
    - アイコンの位置、マウスがアイコン上に来たときの描画機能などを追加

<!-- dummy comment line for breaking list -->


- - - -
`Java 1.6.0`では、`JTabbedPane`のタブ部分に、文字列・アイコンに加え`Swing`コンポーネントが使えるようになっているので、上記のサンプルはもっと簡単に実現できるようになっています。

- [JTabbedPaneにタブを閉じるボタンを追加](http://terai.xrea.jp/Swing/TabWithCloseButton.html)
- [Java SE 6 Mustangの新機能](http://www.02.246.ne.jp/~torutk/jvm/mustang.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing (Archive) - Adding a close icon to a JTabbedPane tab](https://forums.oracle.com/thread/1501884)
- [Swing - JTabbedPane with close Icons](https://forums.oracle.com/thread/1356993)
- [Swing (Archive) - Closable Tab in JTabbedPane](https://forums.oracle.com/thread/1480617)
- [CloseAndMaxTabbedPane: An enhanced JTabbedPane](http://www.javaworld.com/javaworld/jw-09-2004/jw-0906-tabbedpane.html)
- [InfoNode - Java Components](http://www.infonode.net/index.html?itp)
- [Kirill Grouchnikov's Blog: Spicing up your JTabbedPane - part II](http://weblogs.java.net/blog/kirillcool/archive/2005/12/spicing_up_your_1.html)
- [JTabbedPaneでタブを追加削除](http://terai.xrea.jp/Swing/TabbedPane.html)
- [More Enhancements in Java SE 6](http://java.sun.com/developer/technicalArticles/J2SE/Desktop/javase6/enhancements/)

<!-- dummy comment line for breaking list -->

### コメント