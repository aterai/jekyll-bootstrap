---
layout: post
title: JTabbedPaneにタブを閉じるボタンを追加
category: swing
folder: TabWithCloseButton
tags: [JTabbedPane, JButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-01-29

## JTabbedPaneにタブを閉じるボタンを追加
`JDK 6`の新機能を使って`JTabbedPane`にタブを閉じるボタンを追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTVCzHeo0I/AAAAAAAAAnA/hnMCEbHXnnw/s800/TabWithCloseButton.png)

### サンプルコード
<pre class="prettyprint"><code>class CloseButtonTabbedPane extends JTabbedPane {
  private final Icon icon;
  private final Dimension buttonSize;
  public CloseButtonTabbedPane(Icon icon) {
    super();
    //icon = new CloseTabIcon();
    this.icon = icon;
    buttonSize = new Dimension(icon.getIconWidth(), icon.getIconHeight());
  }
  public void addTab(String title, final JComponent content) {
    JPanel tab = new JPanel(new BorderLayout());
    tab.setOpaque(false);
    JLabel label = new JLabel(title);
    label.setBorder(BorderFactory.createEmptyBorder(0,0,0,4));
    JButton button = new JButton(icon);
    button.setPreferredSize(buttonSize);
    button.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        removeTabAt(indexOfComponent(content));
      }
    });
    tab.add(label,  BorderLayout.WEST);
    tab.add(button, BorderLayout.EAST);
    tab.setBorder(BorderFactory.createEmptyBorder(2,1,1,1));
    super.addTab(null, content);
    setTabComponentAt(getTabCount()-1, tab);
  }
}
</code></pre>

### 解説
`JDK 6`から追加されたタブにコンポーネントを配置する機能を使って、`JButton`をタブに追加しています。

[以前のサンプル](http://terai.xrea.jp/Swing/TabWithCloseIcon.html)に比べると、実装も簡単でコードも短くなっています。

### 参考リンク
- [More Enhancements in Java SE 6](http://java.sun.com/developer/technicalArticles/J2SE/Desktop/javase6/enhancements/)
- [How to Use Tabbed Panes (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/tabbedpane.html)
- [JTabbedPaneにタブを閉じるアイコンを追加](http://terai.xrea.jp/Swing/TabWithCloseIcon.html)
- [JTabbedPaneのTabTitleを左揃えに変更](http://terai.xrea.jp/Swing/TabTitleAlignment.html)

<!-- dummy comment line for breaking list -->

### コメント
