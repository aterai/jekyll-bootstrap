---
layout: post
category: swing
folder: InstalledLookAndFeels
title: LookAndFeelの一覧を取得する
tags: [LookAndFeel, UIManager, JMenuBar]
author: aterai
pubdate: 2009-01-19T13:31:06+09:00
description: インストールされているLookAndFeelの一覧を取得し、これらを切り替えるためのメニューバーを作成します。
comments: true
---
## 概要
インストールされている`LookAndFeel`の一覧を取得し、これらを切り替えるためのメニューバーを作成します。[Swingset3 — Project Kenai](https://java.net/projects/Swingset3)からの引用です。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOmfktdJI/AAAAAAAAAco/gBdSD5Qn9-Y/s800/InstalledLookAndFeels.png %}

## サンプルコード
<pre class="prettyprint"><code>private ButtonGroup lookAndFeelRadioGroup;
private String lookAndFeel;
protected JMenu createLookAndFeelMenu() {
  JMenu menu = new JMenu("LookAndFeel");
  lookAndFeel = UIManager.getLookAndFeel().getClass().getName();
  lookAndFeelRadioGroup = new ButtonGroup();
  for (UIManager.LookAndFeelInfo lafInfo: UIManager.getInstalledLookAndFeels()) {
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
      try {
        setLookAndFeel(m.getActionCommand());
      } catch (Exception ex) {
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
  if (!oldLookAndFeel.equals(lookAndFeel)) {
    UIManager.setLookAndFeel(lookAndFeel);
    this.lookAndFeel = lookAndFeel;
    updateLookAndFeel();
    firePropertyChange("lookAndFeel", oldLookAndFeel, lookAndFeel);
  }
}
private void updateLookAndFeel() {
  for (Window window: Frame.getWindows()) {
    SwingUtilities.updateComponentTreeUI(window);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`UIManager.getInstalledLookAndFeels()`メソッドを使用して`UIManager.LookAndFeelInfo`のリストを取得しています。

## 参考リンク
- [Swingset3 — Project Kenai](https://java.net/projects/Swingset3)
- [Look and Feelの変更](http://ateraimemo.com/Swing/LookAndFeel.html)
    - こちらは、`SwingSet2`からの引用です。

<!-- dummy comment line for breaking list -->

## コメント
