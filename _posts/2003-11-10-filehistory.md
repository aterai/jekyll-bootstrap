---
layout: post
category: swing
folder: FileHistory
title: JMenuに最近使ったファイルを追加
tags: [JMenu, JMenuBar, File]
author: aterai
pubdate: 2003-11-10
description: JMenuに「最近使ったファイル(F)」を履歴として追加していきます。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMffElRbI/AAAAAAAAAZQ/1d47Mop5D-0/s800/FileHistory.png
comments: true
---
## 概要
`JMenu`に「最近使ったファイル(`F`)」を履歴として追加していきます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMffElRbI/AAAAAAAAAZQ/1d47Mop5D-0/s800/FileHistory.png %}

## サンプルコード
<pre class="prettyprint"><code>private int MAXHISTORY = 3;
private void updateHistory(String str) {
  fileHistoryMenu.removeAll();
  fileHistoryCache.remove(str);
  fileHistoryCache.add(0, str);
  if (fileHistoryCache.size() &gt; MAX_HISTORY) {
    fileHistoryCache.remove(fileHistoryCache.size() - 1);
  }
  for (int i = 0; i &lt; fileHistoryCache.size(); i++) {
    String name = fileHistoryCache.get(i);
    String num  = Integer.toString(i + 1);
    JMenuItem mi = new JMenuItem(new HistoryAction(name));
    mi.setText(num + ": " + name);
    mi.setMnemonic((int) num.charAt(0));
    fileHistoryMenu.add(mi, i);
  }
}
class HistoryAction extends AbstractAction {
  private final String fileName;
  public HistoryAction(String fileName) {
    super();
    this.fileName = fileName;
  }
  @Override public void actionPerformed(ActionEvent e) {
    Object[] obj = {"本来はファイルを開いたりする。\n",
                    "このサンプルではなにもせずに\n",
                    "履歴の先頭にファイルを移動する。"};
    JComponent c = (JComponent) e.getSource();
    JOptionPane.showMessageDialog(c.getRootPane(), obj, VersionAction.APP_NAME,
        JOptionPane.INFORMATION_MESSAGE);
    updateHistory(fileName);
  }
}
</code></pre>

## 解説
上記のサンプルでは、「ファイル、開く」の`JMenuItem`をクリックするとダミーファイルのオープン履歴が「最近使ったファイル(`F`)」の`JMenu`中に追加されます。

- 履歴`JMenuItem`は`3`件までに制限
- 履歴`JMenuItem`をメニューから選択すると、そのファイルを履歴の先頭に移動(ファイルを開く処理などはない)
    - 実際に使用する場合は、ダミーファイルを使用している箇所を修正したり、アプリケーションを終了する際に履歴を保存したりするコードを追加する必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JMenu (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JMenu.html)
- [Resourceファイルからメニューバーを生成](https://ateraimemo.com/Swing/ResourceMenuBar.html)
- [JFrameの位置・サイズを記憶する](https://ateraimemo.com/Swing/Preferences.html)

<!-- dummy comment line for breaking list -->

## コメント
