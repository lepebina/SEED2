package uk.ac.manchester.cs.img.seed.trace;

import java.lang.reflect.Method;

public class ObjectUtil {
	public static String myToString(Object o) {
        if (overridesToString(o.getClass()))
            return o.toString();
        
        return o.getClass().getSimpleName() + "@" + System.identityHashCode(o);
    }
	
	public static boolean overridesToString(Class<?> clazz) {
        Method m;
        try {
            m = clazz.getMethod("toString");
        } catch (NoSuchMethodException e) {
            return false;
        }
        return (m.getDeclaringClass() != Object.class);
    }
}