---
layout: post
title: LookAndFeelの一覧を取得する
category: swing
folder: InstalledLookAndFeels
tags: [LookAndFeel, UIManager, JMenuBar]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-01-19

## LookAndFeelの一覧を取得する
インストールされている`LookAndFeel`の一覧を取得し、これらを切り替えるためのメニューバーを作成します。[SwingSet3](https://swingset3.dev.java.net/)からの引用です。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOmfktdJI/AAAAAAAAAco/gBdSD5Qn9-Y/s800/InstalledLookAndFeels.png)

### サンプルコード
<pre class="prettyprint"><code>private ButtonGroup lookAndFeelRadioGroup;
private String lookAndFeel;
protected JMenu createLookAndFeelMenu() {
  JMenu menu = new JMenu("LookAndFeel");
  lookAndFeel = UIManager.getLookAndFeel().getClass().getName();
  lookAndFeelRadioGroup = new ButtonGroup();
  for(UIManager.LookAndFeelInfo lafInfo: UIManager.getInstalledLookAndFeels()) {
    menu.add(createLookAndFeelItem(lafInfo.getName(), lafInfo.getClassName()));
  }
  return menu;
}
protected JRadioButtonMenuItem createLookAndFeelItem(String lafName, String lafClassName) {
  JRadioButtonMenuItem lafItem = new JRadioButtonMenuItem();
  lafItem.setSelected(lafClassName.equals(lookAndFeel));
  lafItem.setHideActionText(true);
  lafItem.setAction(new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      ButtonModel m = lookAndFeelRadioGroup.getSelection();
      try{
        setLookAndFeel(m.getActionCommand());
      }catch(Exception ex) {
        ex.printStackTrace();
      }
    }
  });
  lafItem.setText(lafName);
  lafItem.setActionCommand(lafClassName);
  lookAndFeelRadioGroup.add(lafItem);
  return lafItem;
}
public void setLookAndFeel(String lookAndFeel) throws ClassNotFoundException,
      InstantiationException, IllegalAccessException, UnsupportedLookAndFeelException {
  String oldLookAndFeel = this.lookAndFeel;
  if(!oldLookAndFeel.equals(lookAndFeel)) {
    UIManager.setLookAndFeel(lookAndFeel);
    this.lookAndFeel = lookAndFeel;
    updateLookAndFeel();
    firePropertyChange("lookAndFeel", oldLookAndFeel, lookAndFeel);
  }
}
private void updateLookAndFeel() {
  for(Window window: Frame.getWindows()) {
    SwingUtilities.updateComponentTreeUI(window);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`UIManager.getInstalledLookAndFeels()`メソッドを使用して`UIManager.LookAndFeelInfo`のリストを取得しています。

### 参考リンク
- [SwingSet3](https://swingset3.dev.java.net/)
- [Look and Feelの変更](http://terai.xrea.jp/Swing/LookAndFeel.html)
    - こちらは、`SwingSet2`からの引用です。

<!-- dummy comment line for breaking list -->

### コメント
