---
layout: post
title: PersistenceServiceを使ってJFrameの位置・サイズを記憶
category: swing
folder: PersistenceService
tags: [ServiceManager, PersistenceService, JFrame, SwingWorker, XMLEncoder, XMLDecoder]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-03-26

## PersistenceServiceを使ってJFrameの位置・サイズを記憶
`ServiceManager`から`PersistenceService`を取得し、`JFrame`などの位置・サイズの保存、呼び出しを行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-PyOW5DW5kHU/T3APD_Cq_bI/AAAAAAAABKk/i9eivMuQZ0Y/s800/PersistenceService.png)

### サンプルコード
<pre class="prettyprint"><code>final WindowState ws = new WindowState();
SwingWorker&lt;WindowAdapter,Void&gt; worker = new SwingWorker&lt;WindowAdapter,Void&gt;() {
  @Override public WindowAdapter doInBackground() {
    PersistenceService ps;
    BasicService bs;
    try{
      bs = (BasicService)ServiceManager.lookup("javax.jnlp.BasicService");
      ps = (PersistenceService)ServiceManager.lookup("javax.jnlp.PersistenceService");
    }catch(UnavailableServiceException use) {
      use.printStackTrace();
      ps = null;
      bs = null;
    }
    if(ps != null &amp;&amp; bs != null) {
      final PersistenceService persistenceService = ps;
      final URL codebase = bs.getCodeBase();
      loadWindowState(persistenceService, codebase, ws);
      return new WindowAdapter() {
        @Override public void windowClosing(WindowEvent e) {
          JFrame f = (JFrame)e.getComponent();
          if(f.getExtendedState()==JFrame.NORMAL) {
            ws.setSize(f.getSize());
            ws.setLocation(f.getLocationOnScreen());
          }
          saveWindowState(persistenceService, codebase, ws);
        }
      };
    }else{
      return null;
    }
  }
  @Override public void done() {
    WindowAdapter wa = null;
    try{
      wa = get();
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    }catch(Exception e) {
      e.printStackTrace();
    }
    JFrame frame = new JFrame();
    if(wa!=null) frame.addWindowListener(wa);
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(new MainPanel());
    frame.setSize(ws.getSize());
    frame.setLocation(ws.getLocation());
    frame.setVisible(true);
  }
};
worker.execute();
</code></pre>

### 解説
上記のサンプルでは、`PersistenceService`で確保したファイルに、`HashMap<String, Serializable>`に格納した`JFrame`の位置、サイズを`XMLEncoder`、`XMLDecoder`を使って読み書きしています。

- - - -
- `Windows 7`、`JDK 1.7.0_03`では、`C:\Users\(user)\AppData\LocalLow\Sun\Java\Deployment\cache\6.0\muffin`以下に`muf`ファイルなどが作成されるようです。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;java version="1.7.0_03" class="java.beans.XMLDecoder"&gt;
 &lt;object class="java.util.HashMap"&gt;
  &lt;void method="put"&gt;
   &lt;string&gt;location&lt;/string&gt;
   &lt;object idref="Point0"/&gt;
  &lt;/void&gt;
  &lt;void method="put"&gt;
   &lt;string&gt;size&lt;/string&gt;
   &lt;object idref="Dimension0"/&gt;
  &lt;/void&gt;
 &lt;/object&gt;
&lt;/java&gt;
</code></pre>

- - - -
`XMLEncoder`で直接上記の`JFrame`を書きだす場合、以下のような`IllegalAccessException`が発生する

	java.lang.IllegalAccessException: Class sun.reflect.misc.Trampoline can not access a member of class MainPanel$2 with modifiers ""
	Continuing ...

回避するには、`WindowListener`を実装する匿名内部クラスを`public class`(`Java Beans`)に変更するか、`removeWindowListener`で取り除く必要がある

<pre class="prettyprint"><code>//package example;
//-*- mode:java; encoding:utf-8 -*-
// vim:set fileencoding=utf-8:
//@homepage@
import java.awt.*;
import java.awt.event.*;
import java.beans.*;
import java.io.*;
import javax.swing.*;

public class MainPanel extends JPanel {
  private static final String PROPERTIES_XML = "properties.xml";
  public MainPanel() {
    super(new BorderLayout());
    JTextArea textArea = new JTextArea();
    try(Reader fr = new InputStreamReader(
        new FileInputStream(PROPERTIES_XML), "UTF-8")) {
      textArea.read(fr, "File");
    } catch(Exception ex) {
      ex.printStackTrace();
    }
    add(new JScrollPane(textArea));
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch(Exception e) {
      e.printStackTrace();
    }
    JFrame frame = loadFrame();
    frame.setVisible(true);
  }
  private static JFrame loadFrame() {
    JFrame frame = null;
    try(XMLDecoder d = new XMLDecoder(new BufferedInputStream(
        //MainPanel.class.getResourceAsStream(PROPERTIES_XML)))) {
        new FileInputStream(PROPERTIES_XML)))) {

      frame = (JFrame)d.readObject();
      //d.close();
    } catch(Exception ex) {
      ex.printStackTrace();
    }
    if(frame==null) {
      frame = new JFrame("title");
      frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      frame.getContentPane().add(new MainPanel());
      frame.setSize(320, 240);
      frame.setLocationRelativeTo(null);
    }
    frame.addWindowListener(new WindowAdapter() {
      @Override public void windowClosing(WindowEvent e) {
        JFrame frame = (JFrame)e.getComponent();
        frame.removeWindowListener(this);
        File file = new File(PROPERTIES_XML);
        try(XMLEncoder xe = new XMLEncoder(new BufferedOutputStream(
            new FileOutputStream(file)))) {
          xe.writeObject(frame);
          xe.flush();
          //xe.close();
        } catch(Exception ex) {
          ex.printStackTrace();
        }
      }
    });
    return frame;
  }
}
</code></pre>

### 参考リンク
- [JWS javax.jnlp.* API demos](http://pscode.org/jws/api.html)
- [PersistenceService](http://docs.oracle.com/javase/jp/6/technotes/guides/javaws/developersguide/examples.html#PersistenceService)
- [PersistenceService Demo](http://www.finnw.me.uk/persistencetest.html)
- [JFrameの位置・サイズを記憶する](http://terai.xrea.jp/Swing/Preferences.html)

<!-- dummy comment line for breaking list -->

### コメント