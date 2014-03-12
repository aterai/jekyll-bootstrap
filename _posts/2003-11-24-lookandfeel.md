---
layout: post
title: Look and Feelの変更
category: swing
folder: LookAndFeel
tags: [LookAndFeel, JMenuBar]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-11-24

## Look and Feelの変更
アプリケーションの`Look and Feel`を変更します。以下のサンプルコードは、`%JAVA_HOME%/demo/jfc/SwingSet2/src/SwingSet2.java`から引用改変したものです。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPf78s81I/AAAAAAAAAeE/DIOTnqtAOnY/s800/LookAndFeel.png)

### サンプルコード
<pre class="prettyprint"><code>//%JAVA_HOME%/demo/jfc/SwingSet2/src/SwingSet2.java
// Possible Look &amp; Feels
private static final String mac     = "com.sun.java.swing.plaf.mac.MacLookAndFeel";
private static final String metal   = "javax.swing.plaf.metal.MetalLookAndFeel";
private static final String motif   = "com.sun.java.swing.plaf.motif.MotifLookAndFeel";
private static final String windows = "com.sun.java.swing.plaf.windows.WindowsLookAndFeel";
private static final String gtk     = "com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
private static final String nimbus  = "com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel";

// The current Look &amp; Feel
private static String currentLookAndFeel = metal;
private final ButtonGroup lafMenuGroup = new ButtonGroup();
public JMenuItem createLafMenuItem(JMenu menu, String label, String laf) {
  JMenuItem mi = menu.add(new JRadioButtonMenuItem(label));
  lafMenuGroup.add(mi);
  mi.addActionListener(new ChangeLookAndFeelAction(laf));
  mi.setEnabled(isAvailableLookAndFeel(laf));
  return mi;
}
protected static boolean isAvailableLookAndFeel(String laf) {
  try{
    Class lnfClass = Class.forName(laf);
    LookAndFeel newLAF = (LookAndFeel)(lnfClass.newInstance());
    return newLAF.isSupportedLookAndFeel();
  }catch(Exception e) {
    return false;
  }
}
//...
private class ChangeLookAndFeelAction extends AbstractAction{
  private final String laf;
  protected ChangeLookAndFeelAction(String laf) {
    super("ChangeTheme");
    this.laf = laf;
  }
  @Override public void actionPerformed(ActionEvent e) {
    setLookAndFeel(laf);
  }
}
private void setLookAndFeel(String laf) {
  if(currentLookAndFeel.equals(laf)) return;
  currentLookAndFeel = laf;
  try{
    UIManager.setLookAndFeel(currentLookAndFeel);
    SwingUtilities.updateComponentTreeUI(frame);
  }catch(Exception ex) {
    ex.printStackTrace();
    System.out.println("Failed loading L&amp;F: " + currentLookAndFeel);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`metal`、`motif`、`windows`などの`LookAndFeel`を予め用意しておき、`isAvailableLookAndFeel(...)`メソッドで、それらが実行した環境で使用できるかを調べてメニューの選択可不可を変更しています。

`Look and Feel`を切り替えて、いろんなコンポーネントの見栄えを比較したい場合は、`%JAVA_HOME%\demo\jfc\SwingSet2\SwingSet2.jar`がお手軽です。

- - - -
`SwingSet3`では、`UIManager.getInstalledLookAndFeels()`メソッドを使って利用可能な`LookAndFeel`の一覧を取得し、これをメニューに表示しているようです。

- [LookAndFeelの一覧を取得する](http://terai.xrea.jp/Swing/InstalledLookAndFeels.html)

<!-- dummy comment line for breaking list -->

- - - -
`java.exe`などのコマンドオプションでデフォルトの`Look and Feel`を変更する場合は以下のように指定します。

	java.exe -Dswing.defaultlaf=com.sun.java.swing.plaf.windows.WindowsLookAndFeel App

- - - -
`%JAVA_HOME%\lib`以下に`swing.properties`を作ってデフォルトの`Look and Feel`を指定する方法もあります。

- [Specifying the Look and Feel: swing.properties File](http://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html#properties)

<!-- dummy comment line for breaking list -->

- - - -
`SystemLookAndFeel`を使用する場合は、`UIManager.getSystemLookAndFeelClassName()`でその実装クラス名を取得して設定します。

<pre class="prettyprint"><code>try{
  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
}catch(Exception e) {
  e.printStackTrace();
}
</code></pre>

~~`Ubuntu(GNOME)`で、上記のようにシステム`LookAndFeel`を指定すると、`NullPointerException`が発生する場合は、直前に`UIManager.getInstalledLookAndFeels()`を呼んでおくと回避できるようです。~~

- [JDK1.6 で使うと JDK 側のバグ (6389282) に引っかかってしまうのか NPE](http://blogs.sun.com/katakai/entry/omegat_in_mdi_mode)
- [Java6 の痛いバグ… NetBeans デスクトップアプリが Linux で動かず… - Masaki Katakai's Weblog](http://blogs.sun.com/katakai/entry/bad_issue_for_swing_gtk)
- `6u10`で修正済
    - [Bug ID: 6389282 NPE in GTKLookAndFeel.initSystemColorDefaults() on mustang when remote X11 displaying.](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6389282)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [How to Set the Look and Feel](http://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html)
- [LookAndFeelの一覧を取得する](http://terai.xrea.jp/Swing/InstalledLookAndFeels.html)
    - こちらは、`SwingSet3`からの引用です。

<!-- dummy comment line for breaking list -->

### コメント
- スクリーンショットなどを更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-28 (金) 21:37:52

<!-- dummy comment line for breaking list -->

