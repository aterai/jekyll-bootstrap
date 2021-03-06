---
layout: post
category: swing
folder: TabWithCloseButton
title: JTabbedPaneにタブを閉じるボタンを追加
tags: [JTabbedPane, JButton]
author: aterai
pubdate: 2007-01-29T16:15:06+09:00
description: JDK 6の新機能を使用し、JTabbedPaneのタブ内に自身を閉じるためのボタンを追加します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTVCzHeo0I/AAAAAAAAAnA/hnMCEbHXnnw/s800/TabWithCloseButton.png
comments: true
---
## 概要
`JDK 6`の新機能を使用し、`JTabbedPane`のタブ内に自身を閉じるためのボタンを追加します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTVCzHeo0I/AAAAAAAAAnA/hnMCEbHXnnw/s800/TabWithCloseButton.png %}

## サンプルコード
<pre class="prettyprint"><code>class CloseButtonTabbedPane extends JTabbedPane {
  private final Icon icon;
  private final Dimension buttonSize;
  public CloseButtonTabbedPane(Icon icon) {
    super();
    //icon = new CloseTabIcon();
    this.icon = icon;
    buttonSize = new Dimension(icon.getIconWidth(), icon.getIconHeight());
  }
  @Override public void addTab(String title, final JComponent content) {
    JPanel tab = new JPanel(new BorderLayout());
    tab.setOpaque(false);
    JLabel label = new JLabel(title);
    label.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 4));
    JButton button = new JButton(icon);
    button.setPreferredSize(buttonSize);
    button.addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        removeTabAt(indexOfComponent(content));
      }
    });
    tab.add(label,  BorderLayout.WEST);
    tab.add(button, BorderLayout.EAST);
    tab.setBorder(BorderFactory.createEmptyBorder(2, 1, 1, 1));
    super.addTab(null, content);
    setTabComponentAt(getTabCount() - 1, tab);
  }
}
</code></pre>

## 解説
`JDK 6`から追加されたタブ内にコンポーネントを配置する機能を使用して、`JButton`をタブに追加しています。

[以前のサンプル](https://ateraimemo.com/Swing/TabWithCloseIcon.html)に比べると実装も簡単でコードも短くなっています。

## 参考リンク
- [More Enhancements in Java SE 6](http://www.oracle.com/technetwork/articles/javase/index-135776.html)
- [How to Use Tabbed Panes (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/tabbedpane.html)
- [JTabbedPane#setTabComponentAt(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#setTabComponentAt-int-java.awt.Component-)
- [JTabbedPaneにタブを閉じるアイコンを追加](https://ateraimemo.com/Swing/TabWithCloseIcon.html)
- [JTabbedPaneのTabTitleを左揃えに変更](https://ateraimemo.com/Swing/TabTitleAlignment.html)

<!-- dummy comment line for breaking list -->

## コメント
